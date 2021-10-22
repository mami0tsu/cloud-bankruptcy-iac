resource "aws_config_configuration_recorder_status" "default" {
  name = aws_config_configuration_recorder.default.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.default]
}

resource "aws_config_delivery_channel" "default" {
  name = aws_config_configuration_recorder.default.name
  s3_bucket_name = module.config_log_bucket.name
  depends_on = [aws_config_configuration_recorder.default]
}

resource "aws_config_configuration_recorder" "default" {
  name = "default"
  role_arn = aws_iam_service_linked_role.config.arn
  /* Service-Linked ロールが存在している場合
  role_arn = data.aws_iam_role.config.arn
  */

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_iam_service_linked_role" "config" {
  aws_service_name = "config.amazonaws.com"
}

/* Service-Linked ロールが存在している場合
data "aws_iam_role" config {
    name = "AWSServiceRoleForConfig"
}
*/

module "config_log_bucket" {
  source = "./log_bucket_module"
  name = "config-log-mamiotsu"
}

resource "aws_s3_bucket_policy" "config_log" {
  bucket = module.config_log_bucket.name
  policy = data.aws_iam_policy_document.config_log.json
  depends_on = [module.config_log_bucket]
}

data "aws_iam_policy_document" "config_log" {
  statement {
    effect = "Allow"
    actions = ["s3:GetBucketAcl"]
    resources = [module.config_log_bucket.arn]

    principals {
      type = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["${module.config_log_bucket.arn}/AWSLogs/*/Config/*"]

    principals {
      type = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    condition {
      test = "StringEquals"
      variable = "s3:x-amz_acl"
      values = ["bucket-owner-full-control"]
    }
  }
}