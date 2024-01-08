variable "project" {
  type        = string
  description = "The project where resources will be created."
}

variable "region" {
  type        = string
  description = "The region where resources will be created."
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The zone where resources will be created."
  default     = "us-central1-c"
}

variable "ssh_authorized_keys_path" {
  type        = string
  description = "Path to the public SSH key used to access the instance."
  default     = "~/.ssh/id_rsa.pub"
}
