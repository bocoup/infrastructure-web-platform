# Health Checks
# this was created manually in aws sns console because
# it cannot be done via terraform. it sends messages to
# infrastructure@bocoup.com
# TODO make a new health check that is more generic
alert_sns_arn = "arn:aws:sns:us-east-1:682416359150:domainsHealthCheck"
