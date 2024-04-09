terraform init
# To the following for each of the workload environments
# Dev
terraform workspace select dev || terraform workspace new dev
terraform plan
terraform apply

# Test
terraform workspace select test || terraform workspace new test
terraform plan
terraform apply

# Prod
terraform workspace select prod || terraform workspace new prod
terraform plan
terraform apply