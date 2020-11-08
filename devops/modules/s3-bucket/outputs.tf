output "s3BucketArn" {
  value = aws_s3_bucket.codepipeline_bucket.arn
}

output "s3BucketName" {
  value = aws_s3_bucket.codepipeline_bucket.id
}
