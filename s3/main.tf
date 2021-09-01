#------------------------------[Create S3 Bucket]-------------------------------

resource "aws_s3_bucket" "website_bucket" {
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_52: Ensure S3 bucket has MFA delete enabled

  bucket        = var.bucket
  acl           = "private"
  force_destroy = false
  tags          = merge(var.tags, { Name = "${var.project_name} bucket" })

  logging {
    target_bucket = var.log_bucket
    target_prefix = "${var.bucket}/s3_bucket/"
  }

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
}

resource "aws_s3_bucket_object" "state" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "private"
  key    = "state/"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket                  = aws_s3_bucket.website_bucket.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = true
  restrict_public_buckets = true
}

