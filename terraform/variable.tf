variable "ssh_root_user" {
  type = string
}

variable "ssh_host" {
  description = "IP address of the Linux host"
}


variable "ssh_root_private_key" {
  type = string
  sensitive   = true
  default     = ""
}

variable "pod_network_cidr" {
  type = string
  default = "10.244.0.0/16"
}
