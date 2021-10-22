resource "aws_accessanalyzer_analyzer" "default" {
  analyzer_name = "default"
}

resource "aws_cloudwatch_event_target" "access_analyzer" {
  target_id = "access-analyzer"
  rule = aws_cloudwatch_event_rule.access_analyzer.name
  arn = data.aws_sns_topic.mail.arn

  input_transformer {
    input_paths = {
      "type" = "$.detail.resourceType"
      "resource" = "$.detail.resource"
      "action" = "$.detail.action"
    }

    input_template = <<EOF
      "<type>/<resource> allows public access."
      "Action granted: <action>"
    EOF
  }
}

resource "aws_cloudwatch_event_rule" "access_analyzer" {
  name = "access-analyzer"

  event_pattern = jsonencode({
    source = ["aws.access-analyzer"]
    detail-type = ["Access Analyzer Finding"]
    detail ={
      status = ["ACTIVE"]
    }
  })
}

data "aws_sns_topic" "mail" {
  name = "alert-mail"
}