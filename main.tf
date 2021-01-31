#===============================================================================
#
#  Static website full deployment, including:
#    - S3 bucket setup
#    - Route53 setup
#    - CloudFront distribution setup
#    - SSL Certificate
#    - Create user to publish the content of website
#
#===============================================================================

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "NVirginia" # Needed for SSL Certificate
  region = "us-east-1"
}

locals {
  s3_origin_id = "S3-${var.bucket}"
}

resource "aws_acm_certificate" "wildcard" {
  provider                  = aws.NVirginia
  domain_name               = "*.${var.domain}"
  subject_alternative_names = [var.domain]
  tags                      = var.tags
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  dvos = try(tolist(aws_acm_certificate.wildcard.domain_validation_options), [{}])
}

resource "aws_route53_record" "this" {
  allow_overwrite = true
  name            = local.dvos[0].resource_record_name
  records         = [local.dvos[0].resource_record_value]
  ttl             = 60
  type            = local.dvos[0].resource_record_type
  zone_id         = module.route53.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  provider                = aws.NVirginia
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [aws_route53_record.this.fqdn]
}

module "s3" {
  source       = "./s3"
  region       = var.region
  project_name = var.project_name
  tags         = var.tags
  user_id      = module.user.user_id

  depends_on = [module.user.publisher]
}

module "user" {
  source       = "./user"
  region       = var.region
  project_name = var.project_name
  tags         = var.tags
  bucket       = var.bucket
}

module "cloudfront" {
  source       = "./cloudfront"
  bucket       = module.s3.bucket_id
  bucket_arn   = module.s3.bucket_arn
  bucket_dn    = module.s3.bucket_dn
  region       = var.region
  domain       = var.domain
  project_name = var.project_name
  s3_origin_id = local.s3_origin_id
  cert_arn     = aws_acm_certificate.wildcard.arn
  user_arn     = module.user.user_arn
  tags         = var.tags

  depends_on = [module.s3.website_bucket, aws_acm_certificate.wildcard]
}

module "route53" {
  source                 = "./route53"
  region                 = var.region
  project_name           = var.project_name
  domain                 = var.domain
  cloudfront_zone_id     = module.cloudfront.cloudfront_zone_id
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  spf                    = var.spf
  dkim                   = var.dkim
  dmarc                  = var.dmarc
  mx                     = var.mx
  tags                   = var.tags

  depends_on = [module.cloudfront.website_cloudfront]
}
