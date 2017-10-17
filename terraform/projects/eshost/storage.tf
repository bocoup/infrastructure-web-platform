##
# This will be used to store pre-built cross-compiled binaries for a variety of
# JavaScript engines and runtimes.
#
resource "aws_s3_bucket" "builds" {
  bucket = "eshost-builds"
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
        "arn:aws:s3:::eshost-builds",
        "arn:aws:s3:::eshost-builds/*"
      ]
    }
  ]
}
EOF
}
