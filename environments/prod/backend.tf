terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-states"
    key    = "environments/prod/terraform.tfstate"
    region = "eu-west-1"
  }
}
