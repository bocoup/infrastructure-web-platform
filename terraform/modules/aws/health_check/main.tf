variable "fqdn" { }
variable "type" { default = "HTTPS" }
variable "port" { default = "443" }
variable "alert_sns_arn" { }

resource "aws_route53_health_check" "main" {
  fqdn = "${var.fqdn}"
  type = "${var.type}"
  port = "${var.port}"
  resource_path = "/"
  failure_threshold = "10"
  request_interval = "30"
  # a request interval of 30 seconds actually means ping for health every
  # few seconds because there are health checkers at datacenters around
  # the world which are not perfectly coordinated.
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name = "health of ${var.fqdn}"
  metric_name = "HealthCheckStatus"
  namespace = "AWS/Route53"
  dimensions = {
    HealthCheckId = "${aws_route53_health_check.main.id}"
  }
  period = "60"
  evaluation_periods = "1"
  threshold = "1"
  comparison_operator = "LessThanThreshold"
  statistic = "Minimum" # we are only sampling once before evaluation
                        # so this can actually be anything, there is no
                        # aggregate function applied to the received
                        # data
  alarm_actions = ["${var.alert_sns_arn}"]
  ok_actions = ["${var.alert_sns_arn}"]
  alarm_description = "Health monitoring for ${var.fqdn}."
}
