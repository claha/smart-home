terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "6.9.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = "~/.oci/key.pem"
  fingerprint      = var.fingerprint
  region           = var.region
}
