provider "oci" {
  region = var.region
}

module "networking" {
  source         = "./networking"
  compartment_id = var.compartment_id
  region         = var.region
}