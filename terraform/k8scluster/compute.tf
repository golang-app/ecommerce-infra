# maybe use oci_core_instance_pool instead of oci_core_instance?
resource "oci_core_instance" "cp_instances" {
  count               = var.no_control_planes
  availability_domain = lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[count.index+1], "name")
  compartment_id      = var.compartment_id
  display_name        = "cp-${count.index}"
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    assign_public_ip = true
    private_ip       = "10.240.0.1${count.index}"
    subnet_id        = oci_core_subnet.subnet.id
  }

  freeform_tags = {
    "project" = "k8s-cluster"
    "role"    = "controller"
  }

  metadata = {
    "ssh_authorized_keys" = tls_private_key.ssh.public_key_openssh
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = tls_private_key.ssh.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ufw allow from 10.240.0.0/24;sudo iptables -A INPUT -i ens3 -s 10.240.0.0/24 -j ACCEPT;sudo iptables -F",
    ]
  }
}

# maybe use oci_core_instance_pool instead of oci_core_instance?
resource "oci_core_instance" "worker_instances" {
  count               = var.no_workers
  availability_domain = lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[count.index+1], "name")
  compartment_id      = var.compartment_id
  display_name        = "worker-${count.index}"
  shape               = "VM.Standard.A1.Flex"
  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu.images[0].id
    source_type = "image"
  }

  create_vnic_details {
    assign_public_ip = true
    private_ip       = "10.240.0.2${count.index}"
    subnet_id        = oci_core_subnet.subnet.id
  }

  freeform_tags = {
    "project"  = "k8s-cluster"
    "role"     = "worker"
    "pod-cidr" = "10.200.${count.index}.0/24"
  }

  metadata = {
    "ssh_authorized_keys" = tls_private_key.ssh.public_key_openssh
  }
}
