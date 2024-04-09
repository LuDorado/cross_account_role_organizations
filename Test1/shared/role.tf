data "aws_iam_policy_document" "multiaccount_assume_role" {
    statement {
      effect = "Allow"
      actions = "sts:AssumeRole"
      resources = [ 
        "arn:aws:iam::${local.workload_accounts_id}:role/terraform role"
       ]
    }
}
resource "aws_iam_role" "multiaccount_role" {
    name = "terraform-multi-account-role"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.multiaccount_assume_role.json
  
}
data "aws_iam_policy_document" "multiaccount_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]

    resources = ["arn:aws:s3:::${local.project_name}-terraform-state"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListObject",
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project_name}-terraform-state/*",
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
      "arn:aws:dynamodb:*:*:table/${local.project_name}-state-lock",
    ]
  }
}