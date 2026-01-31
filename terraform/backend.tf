terraform {
  backend "s3" {
    bucket         = "example-eks-terraform-state"
    key            = "platform/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}