terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-dev-bucket"
    key    = "dev/terraform.tfstate"
    region = "eu-west-1"
  }
}
