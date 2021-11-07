resource "aws_iam_role_policy_attachment" "example" { 
  role = aws_iam_role.example.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_role" "example" {
  name = "example"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
      principals {
        type = "AWS"
        identifiers = [data.aws_caller_identity.current.account_id]
      }
  }
}

data "aws_caller_identity" "current" {}
