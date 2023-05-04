resource "null_resource" "worker_kubeconfig_set_cluster" {
  count = var.no_workers

  provisioner "local-exec" {
    command = "kubectl config set-cluster k8s-cluster --certificate-authority=ca.pem --embed-certs=true --server=https://${oci_load_balancer_load_balancer.load_balancer.ip_address_details.0.ip_address}:6443 --kubeconfig=worker-${count.index}.kubeconfig"
  }

  depends_on = [
    local_file.ca_cert
  ]
}

resource "null_resource" "worker_kubeconfig_set_credentials" {
  count = var.no_workers

  provisioner "local-exec" {
    command = <<EOF
    kubectl config set-credentials system:node:worker-${count.index} \
    --client-certificate=worker-${count.index}.pem \
    --client-key=worker-${count.index}-key.pem \
    --embed-certs=true \
    --kubeconfig=worker-${count.index}.kubeconfig
EOF
  }

  depends_on = [
    local_file.worker_cert
  ]
}
