variable "region" {
    description = "Project region"
    type = string
    default = "us-east-1"
}
variable "account_mapping" {
    description= "Workload accounts"
    type = map(object({ 
    }))
  
}
variable "projectt_name" {
    description = "Name of the project where tfstate will be stored"
    type = string
}
variable "tags" {
    description = "value"
    type = map(object({
      name = "workspace"
      terraform = true
    }))
}