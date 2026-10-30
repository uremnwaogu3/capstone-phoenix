variable "aws_region" {
  description = "The aws region for the resources"
  type        = string
}

variable "project_name" {
  description = "The project name for the resources"
  type        = string
  default     = "uremapp"
}

variable "admin_cidr" {
  description = "My public IP in CIDR format"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid CIDR and must not be 0.0.0.0/0."
  }
}

variable "public_key_path" {
  description = "the path to the ssh public key to install on the servers"
  type        = string
  default     = "~/.ssh/uremapp.pub"

}

variable "worker_count" {
  description = "Number of worker nodes (server + workers must be at least 3)"
  type        = number
  default     = 2

  validation {
    condition     = var.worker_count >= 2
    error_message = "The brief requires 3+ nodes, so worker_count must be at least 2."
  }
}

variable "server_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "worker_instance_type" {
  type    = string
  default = "t3.small"
}
