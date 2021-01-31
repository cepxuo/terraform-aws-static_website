#------------------------------[Create S3 Bucket]-------------------------------

resource "aws_s3_bucket" "website_bucket" {
  bucket        = var.bucket
  acl           = "private"
  force_destroy = false
  tags          = merge(var.tags, { Name = "${var.project_name} bucket" })

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "delete-noncurrent-after-30-days"
    enabled = true

    noncurrent_version_expiration {
      days = 30
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_object" "website" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "private"
  key    = "website/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "state" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "private"
  key    = "state/"
  source = "/dev/null"
}

resource "aws_s3_bucket_object" "logs" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "private"
  key    = "logs/"
  source = "/dev/null"
}