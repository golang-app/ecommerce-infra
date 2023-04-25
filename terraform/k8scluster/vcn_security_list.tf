resource "oci_core_security_list" "intra" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "intra-vcn"

  ingress_security_rules {
    stateless   = true
    protocol    = "all"
    source      = "10.240.0.0/24"
    source_type = "CIDR_BLOCK"
  }
}

resource "oci_core_security_list" "ssh" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "ssh"

  ingress_security_rules {
    stateless   = false
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_security_list" "worker" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "worker"

  ingress_security_rules {
    stateless   = false
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 30000
      max = 32767
    }
  }
}

resource "oci_core_security_list" "load-ballancer" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "oad-ballancer"

  ingress_security_rules {
    stateless   = false
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"

    tcp_options {
      min = 6443
      max = 6443
    }
  }
}