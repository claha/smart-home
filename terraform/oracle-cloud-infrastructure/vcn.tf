module "vcn" {
  source                  = "oracle-terraform-modules/vcn/oci"
  version                 = "3.5.4"
  compartment_id          = oci_identity_compartment.compartment.id
  region                  = var.region
  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}

resource "oci_core_subnet" "subnet" {
  compartment_id    = oci_identity_compartment.compartment.id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.security-list.id]
  display_name      = "subnet"
}

resource "oci_core_security_list" "security-list" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = module.vcn.vcn_id
  display_name   = "security-list"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1" # ICMP
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1" # ICMP
    icmp_options {
      type = 3
    }
  }
}
