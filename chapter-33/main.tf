resource "aws_iam_role_policy_attachment" "admin" {
  role = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role" "admin" {
  name = "admin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role = aws_iam_role.readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role" "readonly" {
  name = "readonly"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [data.aws_iam_user.base.arn]
    }

    condition {
      test = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values = ["true"]
    }
  }
}

data "aws_iam_user" "base" {
  user_name = "base"
}

data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "assume_role_access" {
  name = "assume-role-access"
  policy = data.aws_iam_policy_document.assume_role_access.json
}

data "aws_iam_policy_document" "assume_role_access" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      data.aws_iam_role.readonly.arn,
      data.aws_iam_role.admin.arn,
    ]
  }
}

data "aws_iam_role" "readonly" {
  name = "readonly"
}

data "aws_iam_role" "admin" {
  name = "admin"
}

resource "aws_iam_policy" "rotate_access_key_access" {
  name = "rotate-access-key-access"
  policy = data.aws_iam_policy_document.rotate_access_key_access.json
}

data "aws_iam_policy_document" "rotate_access_key_access" {
  statement {
    effect = "Allow"
    actions = [
      "iam:CreateAccessKey",
      "iam:UpdateAccessKey",
      "iam:DeleteAccessKey",
      "iam:ListAccessKeys",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
    ]
    resources = ["arn:aws:iam::${local.account_id}:user/&{aws:username}"]
  }
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_group" "assumable" {
  name = "assumable"
}

resource "aws_iam_group_policy_attachment" "assume_role_access" {
  group = aws_iam_group.assumable.name
  policy_arn = aws_iam_policy.assume_role_access.arn
}

resource "aws_iam_group_policy_attachment" "rotate_access_key_access" {
  group = aws_iam_group.assumable.name
  policy_arn = aws_iam_policy.rotate_access_key_access.arn
}

resource "aws_iam_user" "base" {
  name = "base"
  force_destroy = true
}

resource "aws_iam_group_membership" "assumable" {
  name = aws_iam_group.assumable.name
  group = aws_iam_group.assumable.name
  users = [aws_iam_user.base.name]
}
