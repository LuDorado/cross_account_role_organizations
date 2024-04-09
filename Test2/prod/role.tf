data "aws_caller_identity" "name" {
  
}
data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
      actions = [ 
        "sts:AssumeRole" 
      ]
      principals {
        type = "AWS"
        identifiers = "arn:aws:iam::${var.trusted_account_id}/root"
      }
    }
}
resource aws_iam_role "terraform_role" {
    name = "allow-shared-execute-terraform"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "permission-to-achieve" {
  role = aws_iam_role.terraform_role
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.name.account_id}:policy/AdministratorAccess"
}