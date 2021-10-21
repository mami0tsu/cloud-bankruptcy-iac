resource "aws_budgets_budget" "monthly_cost" {
  name = "MonthlyCost"
  budget_type = "COST"
  limit_amount = "10.0"
  limit_unit = "USD"
  time_unit = "MONTHLY"
  time_period_start = "2020-01-01_00:00"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 80
    threshold_type = "PERCENTAGE"
    notification_type = "ACTUAL"
    subscriber_email_addresses = [""]
  }
}