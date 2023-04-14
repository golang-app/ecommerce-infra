variable "availability_domain1" {
  default = "XUcK:EU-FRANKFURT-1-AD-1"
}

variable "availability_domain2" {
  default = "XUcK:EU-FRANKFURT-1-AD-2"
}

variable "availability_domain3" {
  default = "XUcK:EU-FRANKFURT-1-AD-3"
}

variable "internet_gateway_enabled" {
  default = "true"
}

variable "region" {
  default = "eu-frankfurt-1"
}

variable "compartment_id" {}


variable "node_pool_node_shape" {
    default = "VM.Standard.A1.Flex"
}

variable "node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_type" {
    default = "TERMINATE"
}

variable "node_pool_node_config_details_placement_configs_preemptible_node_config_preemption_action_is_preserve_boot_volume" {
    default = "false"
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_cni_type" {
    default = "FLANNEL_OVERLAY"
}

variable "max_pods_per_node" {
    default = "0"
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_pod_nsg_ids" {
    default = []
}

variable "node_pool_node_config_details_node_pool_pod_network_option_details_pod_subnet_ids" {
    default = []
}

variable "node_pool_node_config_details_placement_configs_availability_domain" {
    default = "3"
}

variable "is_force_delete_after_grace_duration" {
    default = "false"
}

variable "node_pool_node_config_details_nsg_ids" {
    default = []
}

variable "eviction_grace_duration" {
    default = "PT1H"
}

variable "node_pool_node_metadata" {
    default = {}
}

variable "node_pool_node_shape_config_memory_in_gbs" {
    default = "32"
}

variable "node_pool_node_shape_config_ocpus" {
    default = "4"
}

variable "node_pool_node_source_details_source_type" {
    default = "IMAGE"
}

variable "node_pool_quantity_per_subnet" {
    default = "1"
}

variable "node_pool_subnet_ids" {
    default = []
}

variable "node_pool_node_config_details_size" {
    default = "3"
}
