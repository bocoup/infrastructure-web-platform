resource "aws_s3_bucket" "backup" {
  bucket = "web-platform-backups"
  region = "us-east-1"
}

resource "aws_s3_bucket" "main" {
  acl = "public-read"
  bucket = "web-platform-assets"
  region = "us-east-1"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::web-platform-assets",
        "arn:aws:s3:::web-platform-assets/*"
      ]
    }
  ]
}
EOF
}

