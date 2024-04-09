provider "aws" {
  region     = var.region

  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn    = "arn:aws:iam::01234567890:role/role_in_account_b"
    # (Optional) The external ID created in step 1c.
    external_id = "my_external_id"
  }
}


resource aws_iam_policy "terraform_access" {
    name = "terraform-access"
    description = "Allow interaction with the tfstate storage"
    policy = data.aws_iam_policy_document.terraform_access.json
}
data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
      actions = [ 
        "sts:AssumeRole" 
      ]
      principals {
        
      }
    }
}
resource aws_iam_role "terraform_role" {
    name = "terraform-role"
}