# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnets in eu-west-1a, eu-west-1b, and eu-west-1c
data "aws_subnet" "default_subnet_1a" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "eu-west-1a"
  default_for_az    = true
}

data "aws_subnet" "default_subnet_1b" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "eu-west-1b"
  default_for_az    = true
}

data "aws_subnet" "default_subnet_1c" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "eu-west-1c"
  default_for_az    = true
}

resource "aws_key_pair" "my-key"{
    key_name=var.keys
    public_key = file("iac-key.pub")
}

# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-name
  }
}

# Create a security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ec2-sg-name
  }
}

# Create an Application Load Balancer
resource "aws_lb" "main" {
  name               = var.alb-name
  internal           = false
  load_balancer_type = var.lb-type
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = [
    data.aws_subnet.default_subnet_1a.id,
    data.aws_subnet.default_subnet_1b.id,
    data.aws_subnet.default_subnet_1c.id
  ]

  tags = {
    Name = var.alb-name
  }
}

# Create a target group for the ALB
resource "aws_lb_target_group" "main" {
  name     = var.alb-tg-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.alb-tg-name
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# Create an EC2 launch template
resource "aws_launch_template" "main" {
  name_prefix   = "main-launch-template"
  image_id      = var.ami-id # Ubuntu AMI
  instance_type = var.ec2_type
  key_name = aws_key_pair.my-key.key_name
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(file("install_pkg_config.sh"))


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-instance"
    }
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "main" {
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [
    data.aws_subnet.default_subnet_1a.id,
    data.aws_subnet.default_subnet_1b.id,
    data.aws_subnet.default_subnet_1c.id
  ]
  target_group_arns    = [aws_lb_target_group.main.arn]
  health_check_type    = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }
}

# Create an Auto Scaling policy for scaling out
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main.name
}

# Create an Auto Scaling policy for scaling in
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main.name
}

# CloudWatch metric alarm for scaling out based on CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high-cpu-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}

# CloudWatch metric alarm for scaling in based on CPU utilization
resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  alarm_name          = "low-cpu-usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }
}
