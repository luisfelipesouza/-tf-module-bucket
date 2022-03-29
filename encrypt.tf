resource "aws_kms_key" "kms" {
  count       = var.server_side_encrypt == "true" ? 1 : 0
  description = lower("bucket-${local.identifier}")

  tags = {
    environment   = lower(var.environment)
    application   = lower(var.application)
    cost-center   = lower(var.cost-center)
    deployed-by   = lower(var.deployed-by)
  }
}

resource "aws_kms_alias" "alias" {
  count         = var.server_side_encrypt == "true" ? 1 : 0
  name          = "alias/bucket-${local.identifier}"
  target_key_id = aws_kms_key.kms[0].key_id
  depends_on    = [aws_kms_key.kms]
}