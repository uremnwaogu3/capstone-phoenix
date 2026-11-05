variable "name" {
  type = string

}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string

}

variable "public_key" {
  description = "contains the ssh of the public key"
  type        = string

}

variable "worker_count" {
  description = "The number of worker nodes"
  type        = number
}

variable "server_instance_type" {
  type = string
}

variable "worker_instance_type" {
  type = string
}

variable "disk_size_gb" {
  type    = number
  default = 30
}
