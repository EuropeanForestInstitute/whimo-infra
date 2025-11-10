resource "aws_s3_bucket" "env" {
  for_each = var.environments
  bucket   = "${var.project_name}-${each.key}-data"

  tags = {
    Environment = each.key
    Name        = "${var.project_name}-${each.key}-data"
  }
}

resource "aws_s3_bucket_ownership_controls" "env" {
  for_each = var.environments
  bucket   = aws_s3_bucket.env[each.key].id
  rule { object_ownership = "BucketOwnerEnforced" }
}

resource "aws_s3_bucket_public_access_block" "env" {
  for_each = var.environments
  bucket                  = aws_s3_bucket.env[each.key].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
