variable "project_name" {
  description = "Project name used for the bootstrap service"
  type        = string
  default     = "uremapp"
}

variable "aws_region" {
  description = "AWS region for the state resources"
  type        = string
}

variable "state_bucket" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string

}

variable "lock_table" {
  description = "DynamoDB table name for state locking"
  type        = string
  default     = "phoenix-tf-lock"
}