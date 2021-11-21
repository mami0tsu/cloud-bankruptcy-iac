terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.63.0"
    }
  }

  required_version = "~> 1.0.9"
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}
