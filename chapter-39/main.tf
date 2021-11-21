module "athena_query_result_bucket" {
  source = "./log_bucket_module"
  name = "athena_query_result"
}

resource "aws_athena_database" "security_log" {
  name = "security_log"
  bucket = module.athena_query_result_bucket.name
}
