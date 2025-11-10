terraform {
  backend "s3" {
    bucket         = "your-s3-backend-bucket"
    key            = "your-project/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}
