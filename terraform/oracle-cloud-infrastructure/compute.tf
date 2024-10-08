data "oci_identity_availability_domain" "availability_domain" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "instance" {
  count               = 2
  availability_domain = data.oci_identity_availability_domain.availability_domain.name
  compartment_id      = oci_identity_compartment.compartment.id
  shape               = "VM.Standard.E2.1.Micro"
  source_details {
    boot_volume_size_in_gbs = 90
    source_id               = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaauqrdu5lmnl4jinnrrw2etwmqmqez4ey2q72dcaqad4ayiehthira"
    source_type             = "image"
  }
  display_name = "oci-${count.index}"
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
  value = [for i in oci_core_instance.instance : i.public_ip]
}
