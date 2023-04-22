variable "compartment_id" {
  type = string
}

variable "region" {
  type = string
}

variable "no_control_planes" {
  type = number
  default = 1
}

variable "no_workers" {
  type = number
  default = 1
}