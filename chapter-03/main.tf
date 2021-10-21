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

module "use_iam_user_module"  {
  source = "./iam_user_module"
  user_name = "terraform"
}

output "arn" {
  value = module.use_iam_user_module.arn
}