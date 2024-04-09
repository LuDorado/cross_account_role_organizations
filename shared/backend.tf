resource "aws_s3_bucket" "terraform_state" {
    bucket = var.bucket_name
    tags = var.tags
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
  name = var.bucket_name
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 1
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

data "aws_iam_policy_document" "terraform_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]

    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    resources = [
      "arn:aws:dynamodb:*:*:table/${var.bucket_name}",
    ]
  }
}

resource aws_iam_policy "terraform_access" {
    name = "terraform-access"
    path = "/"
    description = "Allow interaction with the tfstate storage"
    policy = data.aws_iam_policy_document.terraform_access.json
}