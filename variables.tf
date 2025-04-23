variable "keys"{
    description = "ec2 keys"
    default = "iac-keys"
    type = string
}

variable "alb-sg-name" {
    default = "alb-security-group"
    type = string
  
}

variable "ec2-sg-name" {
  default = "ec2-security-group"
  type = string
}

variable "alb-name" {
    default = "main-alb"
    type = string
  
}

variable "lb-type" {
  default = "application"
  type = string
}

variable "alb-tg-name" {
  default = "main-target-group"
  type = string
}

variable "ami-id" {
  default = "ami-0df368112825f8d8f"
  type = string
}


variable "ec2_type" {
  default = "t2.micro"
  type = string
}
