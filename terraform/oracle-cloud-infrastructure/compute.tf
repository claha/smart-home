data "oci_identity_availability_domain" "availability_domain" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "instance" {
  availability_domain = data.oci_identity_availability_domain.availability_domain.name
  compartment_id      = oci_identity_compartment.compartment.id
  shape               = "VM.Standard.E2.1.Micro"
  source_details {
    source_id   = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaaueqwi7bpc5teyemjxum2eqsy566w4cam3jjsdcgakbwi6zanzwia"
    source_type = "image"
  }
  display_name = "cloud-monitor"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.subnet.id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_authorized_keys_path)
  }
  preserve_boot_volume = false
}

output "public-ip-for-instance" {
  value = oci_core_instance.instance.public_ip
}
