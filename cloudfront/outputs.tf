#-----------------------------------[Outputs]-----------------------------------

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.website_cloudfront.hosted_zone_id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website_cloudfront.domain_name
}
