resource "aws_config_config_rule" "restricted_ssh" {
  name = "restricted-ssh"
  description = "SSHポートがIPアドレス制限をしている確認します。"

  source {
    owner = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  scope {
    compliance_resource_types = [
      "AWS::EC2::SecurityGroup"
    ]
  }
}

resource "aws_config_remediation_configuration" "restricted_ssh"{
  config_rule_name = aws_config_config_rule.restricted_ssh.name
  resource_type = "AWS::Config::RemediationConfiguration"
  target_type = "SSM_DOCUMENT"
  target_id = "AWS-DisablePublicAccessForSecurityGroup"

  parameter {
    name = "GroupId"
    resource_value = "RESOURCE_ID"
  }
  parameter {
    name = "AutomationAssumeRole"
    resource_value = "module.automation_security_group_iam_role.arn"
  }
}

module "automation_security_group_iam_role" {
  source = "./iam_role_module"
  name = "automation-security-group"
  identifier = "ssm.amazonaws.com"
  policy = data.aws_iam_policy_document.security_group_access.json
}

data "aws_iam_policy_document" "security_group_access" {
  statement {
    effect = "Allow"
    actions = ["ec2:RevokeSecurityGroupIngress"]
    resources = ["*"]
  }
}
