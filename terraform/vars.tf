variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "region" {
  default = "eu-frankfurt-1"
}

variable "compartment_id" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaal7nuajylushkuhztkgwb7rqzgghwskuxgxoeh4dizx7gyjeaqxnq"
}