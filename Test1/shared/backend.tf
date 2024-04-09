resource "aws_s3_bucket" "terraform_state" {
    bucket = "${local.project_name}-terraform-state"
    tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "terraform_state" {
  depends_on = [
    aws_s3_bucket_public_access_block.terraform_state,
  ]

  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "${local.project_name}-state-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
}
