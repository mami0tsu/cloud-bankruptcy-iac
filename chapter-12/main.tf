resource "aws_cloudtrail" "default" {
  name = "default"
  enable_logging = true
  is_multi_region_trail = true
  include_global_service_events = true
  enable_log_file_validation = true
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.logs.arn}:*"
  cloud_watch_logs_role_arn = module.cloudtrail_iam_role.arn
  s3_bucket_name = module.cloudtrail_log_bucket.name
  depends_on = [aws_s3_bucket_policy.cloudtrail_log]
}
module "cloudtrail_log_bucket" {
  source = "./log_bucket_module"
  name = "cloudtrail-log-mamiotsu"
}

resource "aws_s3_bucket_policy" "cloudtrail_log" {
  bucket = module.cloudtrail_log_bucket.name
  policy = data.aws_iam_policy_document.cloudtrail_log.json
  depends_on = [module.cloudtrail_log_bucket]
}

data "aws_iam_policy_document" "cloudtrail_log" {
  statement {
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [module.cloudtrail_log_bucket.arn]

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = [module.cloudtrail_log_bucket.arn]

    principals {
      type = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    condition {
      test = "StringEquals"
      variable = "s3:x-amz-acl"
      values = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "CloudTrail/logs"
  retention_in_days = 14
}

module "cloudtrail_iam_role" {
    source = "./iam_role_module"
    name = "cloudtrail"
    identifier = "cloudtrai.amazonaws.com"
    policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    effect = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:*:logstream:*"]

    actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
    ]
  }
}