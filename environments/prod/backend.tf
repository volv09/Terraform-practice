terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-state-files"
    key    = "environments/prod/terraform.tfstate"
    region = "eu-west-1"
  }
}
