resource "oci_identity_compartment" "compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Compartment for Terraform"
  name           = "terraform-compartment"
}
