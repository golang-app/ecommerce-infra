output "worker_ips" {
  value = [
    for bd in oci_core_instance.worker_instances : bd.public_ip
  ]
}

output "control_plane_ips" {
  value = [
    for bd in oci_core_instance.cp_instances : bd.public_ip
  ]
}

output "ssh_private_key" {
  value     = tls_private_key.ssh.private_key_openssh
  sensitive = true
}