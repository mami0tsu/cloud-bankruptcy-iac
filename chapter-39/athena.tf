locals {
  create_table = templatefile("${path.module}/create_table.sql", {
    database_name = aws_athena_database.security_log.name
    table_name = "cloudtrail"
    bucket_name = data.aws_s3_bucket.cloudtrail_log.id
    account_id = data.aws_caller_identity.current.account_id
    regions = join(",", data.aws_regions.current.names)
  })
}

data "aws_s3_bucket" "cloudtrail_log" {
  bucket = "cloudtrail-log"
}

data "aws_caller_identity" "current" {}
data "aws_regions" "current" {}

resource "null_resource" "create_table" {
  provisioner "local-exec" {
    command = <<EOT
      aws athena start-query-execution --result-configuration \
      OutputLocation=s3://${module.athena_query_result_bucket.name} \
      --query-string "${local.create_table}"
    EOT
  }

  triggers = {
    create_table = local.create_table
  }
}
