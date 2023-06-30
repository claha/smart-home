variable "tenancy_ocid" {
  type        = string
  description = "The OCID of the tenancy."
}

variable "user_ocid" {
  type        = string
  description = "The OCID of the user."
}

variable "fingerprint" {
  type        = string
  description = "The fingerprint of the API key."
}

variable "region" {
  type        = string
  description = "The region where resources will be created."
  default     = "eu-stockholm-1"
}

variable "ssh_authorized_keys_path" {
  type        = string
  description = "Path to the public SSH key used to access the instance."
  default     = "~/.ssh/id_rsa.pub"
}
