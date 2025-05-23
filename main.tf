provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-example-bucket-999-ai"
}

