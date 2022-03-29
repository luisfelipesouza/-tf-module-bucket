resource "aws_s3_bucket" "bucket_content" {
  bucket        = local.identifier
  force_destroy = true

  tags = {
    stack       = lower(var.environment)
    application = lower(var.application)
    cost-center = lower(var.cost-center)
    deployed-by = lower(var.deployed-by)
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.bucket_content.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.bucket_content.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE","DELETE"]
    allowed_origins = [var.domain]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt" {
  count   = var.server_side_encrypt == "true" ? 1 : 0
  bucket  = aws_s3_bucket.bucket_content.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms[0].arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  identifier    = lower("eventimbra-${var.application}-${var.environment}-${random_id.id.hex}")
}