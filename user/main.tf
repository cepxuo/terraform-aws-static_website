#------------------------------[Create User]-------------------------------

resource "aws_iam_group" "publishers" {
  name = "${var.bucket}_publishers"
}

resource "aws_iam_user" "publisher" {
  name = "${var.bucket}_publisher"
}

resource "aws_iam_group_membership" "publishers" {
  name  = "${var.bucket}_publishers"
  group = aws_iam_group.publishers.name
  users = [aws_iam_user.publisher.name]
}

resource "aws_iam_access_key" "key" {
  user = aws_iam_user.publisher.name
}

resource "aws_iam_group_policy" "policy" {
  name   = "${var.bucket}-access-policy"
  group  = aws_iam_group.publishers.name
  policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "s3:DeleteObjectTagging",
                  "s3:ListBucketMultipartUploads",
                  "s3:DeleteObjectVersion",
                  "s3:ListBucket",
                  "s3:DeleteObjectVersionTagging",
                  "s3:GetBucketAcl",
                  "s3:ListMultipartUploadParts",
                  "s3:PutObject",
                  "s3:GetObjectAcl",
                  "s3:GetObject",
                  "s3:AbortMultipartUpload",
                  "s3:DeleteObject",
                  "s3:GetBucketLocation",
                  "s3:PutObjectAcl"
              ],
              "Resource": [
                  "arn:aws:s3:::${var.bucket}/website/*",
                  "arn:aws:s3:::${var.bucket}"
              ]
          }
      ]
}
EOF
}
