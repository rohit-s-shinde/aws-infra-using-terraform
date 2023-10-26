terraform {
  backend "s3" {
    bucket         = "tf-state-lock-demo-1"
    key            = "aws-tf-demo"
    region         = "ap-south-1"
    dynamodb_table = "tf-lock-state"
  }
}
