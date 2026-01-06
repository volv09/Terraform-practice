terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-staging-bucket"
    key    = "staging/terraform.tfstate"
    region = "eu-west-1"
  }
}
