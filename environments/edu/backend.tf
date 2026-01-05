terraform {
  backend "s3" {
    bucket = "s3-terraform-backend-test-bucket"
    key    = "test/terraform.tfstate"
    region = "eu-west-1"
  }
}
