resource "aws_guardduty_detector" "default" {
  enable = true
  finding_publishing_frequency = "SIX_HOURS"
}

resource "aws_cloudwatch_event_rule" "guardduty" {
  name = "guardduty"

  event_pattern = jsonencode({
      source = ["aws.guardduty"]
      detail-type = ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty" {
  target_id = "guardduty"
  rule = aws_cloudwatch_event_rule.guardduty.name
  arn = data.aws_sns_topic.mail.arn

  input_transformer {
      input_paths = {
        "type" = "$.detail.type"
        "description" = "$.detail.description"
        "severity" = "$.detail.severity"
      }

      input_template =  <<EOF
        "You have a severity <severity> GuardDuty finding type <type>"
        "<description>
      EOF
  }
}

data "aws_sns_topic" "mail" {
    name = "alert-mail"
}