variable "region" {
    description = "Project region"
    type = string
    default = "us-east-1"
}
variable "bucket_name" {
    description = "Name of the buckets where tfstate will be stored"
    type = string
}
variable "tags" {
    description = "value"
    type = map(object({
      name = "workspace-test"
      terraform = true
    }))
}