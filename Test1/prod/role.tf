data "aws_iam_policy_document" "teraraform_assume_role" {
    statement {
      effect = "Allow"
      actions = "sts:AssumeRole"
      resources = [ 
        "arn:aws:iam::${var.shared_account_id}:role/terraform-multiaccount-role"
       ]
    }
}
resource "aws_iam_role" "terraform_role" {
    name = "terraform-role"
    path = "/"
    assume_role_policy = data.aws_iam_policy_document.terraform_assume_role.json
  
}
resource "aws_iam_policy_attachment" "admin_grant" {
  name = "admin-grant-attachement" 
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}