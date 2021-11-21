resource "aws_iam_policy" "tokyo_access" {
  name = "tokyo-access"
  policy = data.aws_iam_policy_document.tokyo_access.json
}

data "aws_iam_policy_document" "tokyo_access" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = ["*"]

    condition {
      test = "StringEquals"
      variable = "aws:RequestedRegion"
      values = ["ap-northeast-1"]
    }
  }
}

resource "aws_iam_policy" "virginia_access" {
  name = "virginia-access"
  policy = data.aws_iam_policy_document.virginia_access.json
}

data "aws_iam_policy_document" "virginia_access" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "iam:*",
      "sts:*",
      "budgets:*",
      "ce:*",
      "cur:*",
      "savingsplans:*",
      "support:*",
      "health:*",
      "organizations:*",
      "route53:*",
      "route53domains:*",
      "cloudfront:*",
      "waf:*",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:RequestedRegion"
      values = ["us-east-1"]
    }
  }
}

resource "aws_iam_policy" "ohio_access" { 
  name = "ohio-access"
  policy = data.aws_iam_policy_document.ohio_access.json
}

data "aws_iam_policy_document" "ohio_access" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "chatbot:*",
      "sts:AssumeRole",
      "iam:PassRole",
    ]

    condition {
      test = "StringEquals"
      variable = "aws:RequestedRegion"
      values = ["us-east-2"]
    }
  }
}

data "aws_iam_policy_document" "regional" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "regional" {
  name = "regional"
  assume_role_policy = data.aws_iam_policy_document.regional.json
}

resource "aws_iam_role_policy_attachment" "tokyo" {
  role = aws_iam_role.regional.name
  policy_arn = aws_iam_policy.tokyo_access.arn
}

resource "aws_iam_role_policy_attachment" "virginia" {
  role = aws_iam_role.regional.name
  policy_arn = aws_iam_policy.virginia_access.arn
}

resource "aws_iam_role_policy_attachment" "ohio" {
  role = aws_iam_role.regional.name
  policy_arn = aws_iam_policy.ohio_access.arn
}

data "aws_iam_policy_document" "assume_role_access" {
  statement {
    effect = "Allow"
    resources = [
      data.aws_iam_role.readonly.arn,
      data.aws_iam_role.regional.arn,
    ]
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_role" "readonly" {
  name = "readonly"
}

data "aws_iam_role" "regional" {
  name = "regional"
}
