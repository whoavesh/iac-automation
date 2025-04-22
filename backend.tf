terraform{
    backend "s3" {
      bucket = "iac-terraform-state-bucket-11"
      key = "dev/terraform.tfstate"
      region = "eu-west-1"
      encrypt = "true"
      dynamodb_table = "terraform-locks"
    }
}
