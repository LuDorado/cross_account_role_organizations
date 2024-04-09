data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
      actions = [ 
        "sts:AssumeRole" 
      ]
      principals {
        type = "AWS"
        identifiers = "arn:aws:iam::${var.trusting_account_id}:role/allow-shared-execute-terraform"
      }
    }
}

resource aws_iam_policy "allow_users_execution" {
    name = "terraform-access"
    path = "/"
    description = "Allow interaction with the tfstate storage"
    policy = data.aws_iam_policy_document.assume_role.json
}
# aws iam attach-user-policy --policy-arn "arn:aws:iam::$(TrustedAccountID):policy/Custom-Assume-Role-Policy" --user-name "user-1"