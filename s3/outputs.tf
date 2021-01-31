#-----------------------------------[Outputs]-----------------------------------

output "bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "bucket_dn" {
  value = aws_s3_bucket.website_bucket.bucket_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
