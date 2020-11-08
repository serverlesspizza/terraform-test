resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.name
  acl = "private"
  tags = var.tags
}
