resource "aws_cloudformation_stack" "chatbot" {
  name = "chatbot"

  template_body = yamlencode({
    Description = "Managed by Terraform"
    Resources = {
      AlertNotifications = {
        Type = "AWS::Chatbot::SlackChannelConfiguration"
        Properties = {
          ConfigurationName = "AlertNotifications"
          SlackWorkspaceId = ""
          SlackChannelId = ""
          IamRoleArn = module.chatbot_iam_role.arn
          SnsTopicArns = [aws_sns_topic.chatbot.arn]
        }
      }
    }
  })
}

module "chatbot_iam_role" {
  source = "./iam_role_module"
  name = "chatbot"
  identifier = "chatbot.amazonaws.com"
  policy = data.aws_iam_policy_document.cloudwatch_access.json
}

data "aws_iam_policy_document" "cloudwatch_access" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
    ]
    resources = ["*"]
  }
}

resource "aws_sns_topic_policy" "chatbot" {
  arn = aws_sns_topic.chatbot.arn
  policy = data.aws_iam_policy_document.chatbot.json
}

data "aws_iam_policy_document" "chatbot" {
  statement {
    effect = "Allow"
    actions = ["sns:Publish"]
    resources = [aws_sns_topic.chatbot.arn]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "cloudwatch.amazonaws.com",
      ]
    }
  }
}

resource "aws_sns_topic" "chatbot" {
  name = "chatbot"
}