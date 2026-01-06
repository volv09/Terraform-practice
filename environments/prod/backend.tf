terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-prod-bucket"
    key    = "prod/terraform.tfstate"
    region = "eu-west-1"
  }
}
