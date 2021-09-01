#-------------------------[S3 Bucket Policy Generation]-------------------------


resource "aws_cloudfront_origin_access_identity" "website_access_identity" {
  comment = "${var.project_name} Access Identity"
}

resource "aws_s3_bucket_policy" "website_s3_bp" {
  bucket = var.bucket
  policy = <<POLICY
{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "${aws_cloudfront_origin_access_identity.website_access_identity.iam_arn}"
              },
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::${var.bucket}/website/*"
          },
          {
              "Sid": "",
              "Effect": "Allow",
              "Principal": {
                  "AWS": "${var.user_arn}"
              },
              "Action": [
                  "s3:*"
              ],
              "Resource": ["arn:aws:s3:::${var.bucket}/website/*",
                           "arn:aws:s3:::${var.bucket}"
              ]
          }
      ]
}
POLICY

  depends_on = [aws_cloudfront_origin_access_identity.website_access_identity]
}

#---------------------------[CloudFront Distribution]---------------------------

resource "aws_cloudfront_distribution" "website_cloudfront" {
  #checkov:skip=CKV_AWS_68: CloudFront Distribution should have WAF enabled
  depends_on          = [aws_cloudfront_origin_access_identity.website_access_identity]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name} CloudFront Distribution"
  default_root_object = "index.html"
  tags                = merge(var.tags, { Name = "${var.project_name} CloudFront Distribution" })
  aliases             = [var.domain]

  logging_config {
    include_cookies = false
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    prefix          = "${var.bucket}/cloudfront/"
  }

  origin {
    domain_name = var.bucket_dn
    origin_id   = var.s3_origin_id
    origin_path = "/website"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_access_identity.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn            = var.cert_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
  }

}
