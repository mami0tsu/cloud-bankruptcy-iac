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

data "aws_iam_policy_document" "admin_acess" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "admin_access" {
  name = "admin-access"
  policy = data.aws_iam_policy_document.admin_acess.json
}

resource "aws_iam_user" "terraform" {
  name = "terraform"
  force_destroy = true
}

resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_membership" "admin" {
  name = aws_iam_group.admin.name
  group = aws_iam_group.admin.name
  users = [aws_iam_user.terraform.name]
}

resource "aws_iam_group_policy_attachment" "admin" {
  group = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.admin_access.arn
}