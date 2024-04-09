variable "region" {
    description = "Project region"
    type = string
    default = "us-east-1"
}
variable "project_name" {
    description = "Name of the buckets where tfstate will be stored"
    type = string
}
variable "tags" {
    description = "value"
    type = map(object({
      name = "workspaces"
      terraform = true
    }))
}