data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = var.compartment_id
}

data "oci_core_images" "ubuntu" {
  compartment_id = var.compartment_id

  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
}