# Health Checks
# this was created manually in aws sns console because
# it cannot be done via terraform. it sends messages to
# infrastructure+web-platform@bocoup.com
alert_sns_arn = "arn:aws:sns:us-east-1:682416359150:web-platform-domains-health-check"
