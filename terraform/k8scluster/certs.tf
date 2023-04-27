resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "My Certificate Authority"
    organization = "My Organization"
  }

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "key_encipherment",
    "client_auth",
    "server_auth"
  ]

  validity_period_hours = 87600 # 10 years
}

resource "tls_cert_request" "csr" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Kubernetes"
    organization = "Kubernetes"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "admin" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "admin"
    organization = "system:masters"
  }

  depends_on = [
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "worker" {
  count           = var.no_workers
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "system:node:${count.index}.subnet.vcn.oraclevcn.com"
    organization = "system:nodes"
  }

  dns_names = [
    oci_core_instance.worker_instances[count.index].display_name,
    oci_core_instance.worker_instances[count.index].private_ip,
    oci_core_instance.worker_instances[count.index].public_ip,
  ]

  depends_on = [
    tls_self_signed_cert.ca,
  ]
}

# send certificates to the control plane nodes
resource "null_resource" "tls_control_plane_cert" {
  count = var.no_control_planes

  triggers = {
    cert_request_pem = tls_self_signed_cert.ca.cert_pem
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = oci_core_instance.cp_instances[count.index].public_ip
    private_key = tls_private_key.ssh.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ufw allow from 10.240.0.0/24;sudo iptables -A INPUT -i ens3 -s 10.240.0.0/24 -j ACCEPT;sudo iptables -F",
      "echo \"${tls_self_signed_cert.ca.cert_pem}\" > ca.pem",
      "echo \"${tls_self_signed_cert.ca.private_key_pem}\" > ca-key.pem",

      "echo \"${tls_cert_request.csr.cert_request_pem}\" > kubernetes.pem",
      "echo \"${tls_cert_request.csr.private_key_pem}\" > kubernetes-key.pem",

      "echo \"${tls_cert_request.service-accounts.cert_request_pem}\" > service-accounts.pem",
      "echo \"${tls_cert_request.service-accounts.private_key_pem}\" > service-accounts-key.pem",
    ]
  }
}

# send certificates to the worker nodes
resource "null_resource" "tls_worker_cert" {
  count = var.no_workers

  triggers = {
    cert_request_pem = tls_cert_request.worker[count.index].cert_request_pem
    private_key_pem  = tls_cert_request.worker[count.index].private_key_pem
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = oci_core_instance.worker_instances[count.index].public_ip
    private_key = tls_private_key.ssh.private_key_openssh
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ufw allow from 10.240.0.0/24;sudo iptables -A INPUT -i ens3 -s 10.240.0.0/24 -j ACCEPT;sudo iptables -F",
      "echo \"${tls_self_signed_cert.ca.cert_pem}\" > ca.pem",
      "echo \"${tls_cert_request.worker[count.index].cert_request_pem}\" > worker-${count.index}.pem",
      "echo \"${tls_cert_request.worker[count.index].private_key_pem}\" > worker-${count.index}-key.pem",
    ]
  }
}

resource "tls_cert_request" "kube-controller-manager" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "system:kube-controller-manager"
    organizational_unit = "Kubernetes Cluster"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-proxy" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "system:node-proxier"
    organizational_unit = "Kubernetes Cluster"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-scheduler" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "system:kube-scheduler"
    organizational_unit = "Kubernetes Cluster"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-api-server" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "Kubernetes"
    organizational_unit = "Kubernetes Cluster"
  }

  dns_names = [
    "10.32.0.1",
    "10.240.0.10",
    "10.240.0.11",
    "10.240.0.12",
    oci_load_balancer_load_balancer.load_balancer.ip_address_details.0.ip_address,
    "127.0.0.1",

    # k8s regular hostnames
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local",
  ]

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "service-accounts" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name         = "Kubernetes"
    organization        = "system:service-accounts"
    organizational_unit = "Kubernetes Cluster"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

# we safe certs to files to be able to use them while creating kubeconfig
resource "local_file" "ca_key" {
  content  = tls_self_signed_cert.ca.private_key_pem
  filename = "ca-key.pem"
}

resource "local_file" "ca_cert" {
  content  = tls_self_signed_cert.ca.cert_pem
  filename = "ca.pem"
}

resource "local_file" "worker_cert" {
  count = var.no_workers

  content  = tls_cert_request.worker[count.index].cert_request_pem
  filename = "worker-${count.index}.pem"
}

resource "local_file" "worker_private_key" {
  count = var.no_workers

  content  = tls_cert_request.worker[count.index].private_key_pem
  filename = "worker-${count.index}-key.pem"
}