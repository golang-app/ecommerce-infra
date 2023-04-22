resource "oci_core_virtual_network" "vcn" {
  cidr_block     = "10.240.0.0/24"
  dns_label      = "vcn"
  compartment_id = var.compartment_id
  display_name   = "kubernetes-the-hard-way"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "kubernetes-the-hard-way"
}

resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id

  display_name = "kubernetes-the-hard-way"
  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination       = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "subnet" {
  cidr_block     = "10.240.0.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id

  display_name      = "kubernetes"
  dns_label         = "subnet"
  route_table_id    = oci_core_route_table.route_table.id
  security_list_ids = [oci_core_security_list.intra.id, oci_core_security_list.worker.id, oci_core_security_list.load-ballancer.id, oci_core_security_list.ssh.id]
}
