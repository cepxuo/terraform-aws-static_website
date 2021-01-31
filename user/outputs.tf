#-----------------------------------[Outputs]-----------------------------------

output "user_id" {
  value = aws_iam_user.publisher.id
}

output "user_access_key" {
  value = aws_iam_access_key.key.id
}

output "user_secret_key" {
  value = aws_iam_access_key.key.secret
}

output "user_arn" {
  value = aws_iam_user.publisher.arn
}
