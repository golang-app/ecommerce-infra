resource "oci_containerengine_cluster" "k8s_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = "v1.25.4"
  name               = "k8s"
  vcn_id             = "ocid1.vcn.oc1.eu-frankfurt-1.amaaaaaatotyoeaajw2pj5grjj4clrpaudji5dttej4mwpc6s4sbuvupxazq"
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaahr7mthgcbgtgcwmfg3ix4dmbjve6srnwc4cqaokwyozudvna62fq"
  }
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
  }
}

resource "oci_containerengine_node_pool" "pool1" {
    #Required
    cluster_id = oci_containerengine_cluster.k8s_cluster.id
    compartment_id = var.compartment_id
    name = "pool1"
    node_shape = var.node_pool_node_shape

    kubernetes_version = "v1.25.4"
    node_config_details {
        #Required
        placement_configs {
            availability_domain = var.availability_domain1
            subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaao7wuozuwgu6gsu5hsrn43xetsb32iumggg2d4errcqfxrvw2wxra"
            fault_domains = [ ]
        }

        placement_configs {
            availability_domain = var.availability_domain2
            subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaao7wuozuwgu6gsu5hsrn43xetsb32iumggg2d4errcqfxrvw2wxra"
            fault_domains = [ ]
        }

        placement_configs {
            availability_domain = var.availability_domain3
            subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaao7wuozuwgu6gsu5hsrn43xetsb32iumggg2d4errcqfxrvw2wxra"
            fault_domains = [ ]
        }

        size = var.node_pool_node_config_details_size

        #Optional
        # is_pv_encryption_in_transit_enabled = var.node_pool_node_config_details_is_pv_encryption_in_transit_enabled
        # kms_key_id = oci_kms_key.test_key.id
        node_pool_pod_network_option_details {
            #Required
            cni_type = var.node_pool_node_config_details_node_pool_pod_network_option_details_cni_type

            #Optional
            max_pods_per_node = var.max_pods_per_node
            pod_nsg_ids = var.node_pool_node_config_details_node_pool_pod_network_option_details_pod_nsg_ids
            pod_subnet_ids = var.node_pool_node_config_details_node_pool_pod_network_option_details_pod_subnet_ids
        }

        nsg_ids = var.node_pool_node_config_details_nsg_ids

       
    }
    node_eviction_node_pool_settings {
        #Optional
        eviction_grace_duration = var.eviction_grace_duration
        is_force_delete_after_grace_duration = var.is_force_delete_after_grace_duration
    }
    # node_image_name = "Oracle-Linux-8.7-aarch64-2023.01.31-3-OKE-1.25.4-549"
    node_metadata = var.node_pool_node_metadata
    node_shape_config {

        #Optional
        memory_in_gbs = var.node_pool_node_shape_config_memory_in_gbs
        ocpus = var.node_pool_node_shape_config_ocpus
    }
    node_source_details {
        #Required
        image_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaapsfsp6tjxpi6oqsjlya7rg2l5dp43mqvj5tliqmwslovhlfcke4a"
        source_type = var.node_pool_node_source_details_source_type
    }
}
