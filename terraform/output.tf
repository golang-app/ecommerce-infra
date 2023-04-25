output "worker_ips" {
  value = module.k8scluster.worker_ips
}

output "control_plane_ips" {
  value = module.k8scluster.control_plane_ips
}

output "ssh_private_key" {
  value     = module.k8scluster.ssh_private_key
  sensitive = true
}