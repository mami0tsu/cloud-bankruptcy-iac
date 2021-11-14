module "cloud_trail_changes" {
  source = "./cloudwatch_alarms_module"
  name = "cloud-trail-changes"
  threshold = 1
  pattern = "{($.eventName=CreateTrail) || ($.eventName=UpdateTrail) || ($.eventName=DeleteTrail) || ($.eventName=StartLogging) || ($.eventName=StopLogging)}"
}

module "aws_config_changes" {
  source = "./cloudwatch_alarms_module"
  name = "aws-config-changes"
  threshold = 1
  pattern = "{($eventSource=config.amazonaws.com) && (($.eventName=StopConfigurationRecorder) || ($.eventName=DeleteDeliveryChannel) || ($.eventName=PutDeliveryChannel) || ($.eventName=PutConfigurationRecorder))}"
}

module "console_sign_in_without_mfa" {
  source = "./cloudwatch_alarms_module"
  name = "console-sign-in-without-mfa"
  threshold = 1
  pattern = "{($.eventName=\"ConsoleLogin\") && ($.additionalEventData.MFAUsed !=\"Yes\")}"
}

module "vpc_changes" {
  source = "./cloudwatch_alarms_module"
  name = "vpc-changes"
  threshold = 1
  pattern = "{($.eventName=CreateVpc) || ($.eventName=DeleteVpc) || ($.eventName=ModifyVpcAttribute) || ($.eventName=AcceptVpcPeeringConnection) || ($.eventName=CreateVpcPeeringConnection) || ($.eventName=DeleteVpcPeeringConnection) || ($.eventName=RejectVpcPeeringConnection) || ($.eventName=AttachClassicLinkVpc) || ($.eventName=DetachClassicLinkVpc) || ($.eventName=DisableVpcClassicLink) || ($.eventName=EnableVpcClassicLink)}"
}

module "gateway_changes" {
  source = "./cloudwatch_alarms_module"
  name = "gateway-changes"
  threshold = 1
  pattern = "{($.eventName=CreateCustomerGateway) || ($.eventName=DeleteCustomerGateway) || ($.eventName=AttachInternetGateway) || ($.eventName=CreateInternetGateway) || ($.eventName=DeleteInternetGateway) || ($.eventName=DetachInternetGateway)}"
}

module "route_table_changes" {
  source = "./cloudwatch_alarms_module"
  name = "route-table-changes"
  threshold = 1
  pattern = "{($.eventName=CreateRoute) || ($.eventName=CreateRouteTable) || ($.eventName=ReplaceRoute) || ($.eventName=ReplaceRouteTableAssociation) || ($.eventName=DeleteRouteTable) || ($.eventName=DeleteRoute) || ($.eventName=DisassociateRouteTable)}"
}

module "network_acl_changes" {
  source = "./cloudwatch_alarms_module"
  name = "network-acl-changes"
  threshold = 1
  pattern = "{($.eventName=CreateNetworkAcl) || ($.eventName=CreateNetworkAclEntry) || ($.eventName=DeleteNetworkAcl) || ($.eventName=DeleteNetworkAclEntry) || ($.eventName=ReplaceNetworkAclEntry) || ($.eventName=ReplaceNetworkAclAssociation)}"
}

module "s3_bucket_policy_changes" {
  source = "./cloudwatch_alarms_module"
  name = "s3-bucket-policy-changes"
  threshold = 1
  pattern = "{($.eventSource=s3.amazonaws.com) && (($.eventName=PutBucketAcl) || ($.eventName=PutBucketPolicy) || ($.eventName=PutBucketCors) || ($.eventName=PutBucketLifecycle) || ($.eventName=PutBucketReplication) || ($.eventName=DeleteBucketPolicy) || ($.eventName=DeleteBucketCors) || ($.eventName=DeleteBucketLifecycle) || ($.eventName=DeleteBucketReplication))}"
}

module "cmk_changes" {
  source = "./cloudwatch_alarms_module"
  name = "cmk-changes"
  threshold = 1
  pattern = "{($.eventSource=kms.amazonaws.com) && (($.eventName=DisableKey) || ($.eventName=ScheduleKeyDeletion))}"
}

module "console_sign_in_failures" {
  source = "./cloudwatch_alarms_module"
  name = "console-sign-in-failures"
  threshold = 3
  pattern = "{($.eventName=ConsoleLogin) && ($.errorMessage=\"Failed authentication\")}"
}

module "authorization_failures" {
  source = "./cloudwatch_alarms_module"
  name = "authorization-failures"
  threshold = 3
  pattern = "{($.errorCode=\"*UnauthorizedOperation\") || ($.errorCode=\"AccessDenied\")}"
}

module "security_group_changes" {
  source = "./cloudwatch_alarms_module"
  name = "security-group-changes"
  threshold = 1
  pattern = "{($.eventName=AuthorizeSecurityGroupIngress) || ($.eventName=AuthorizeSecurityGroupEgress) || ($.eventName=RevokeSecurityGroupIngress) || ($.eventName=RevokeSecurityGroupEngress) || ($.eventName=CreateSecurityGroup) || ($.eventName=DeleteSecurityGroup)}"
}

module "iam_policy_changes" {
  source = "./cloudwatch_alarms_module"
  name = "iam-policy-changes"
  threshold = 1
  pattern = "{($.eventName=DeleteGroupPoliry) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeletePolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"
}
