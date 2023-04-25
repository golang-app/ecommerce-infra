provider "oci" {
  region = var.region
}

module "k8scluster" {
  source         = "./k8scluster"
  compartment_id = var.compartment_id
  region         = var.region
}
