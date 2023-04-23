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
    tls_private_key.ca,
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
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-controller-manager" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Kubernetes"
    organization = "system:kube-controller-manager"
    organizational_unit = "Kubernetes The Hard Way"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-proxy" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Kubernetes"
    organization = "system:node-proxier"
    organizational_unit = "Kubernetes The Hard Way"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-scheduler" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Kubernetes"
    organization = "system:kube-scheduler"
    organizational_unit = "Kubernetes The Hard Way"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}

resource "tls_cert_request" "kube-api-server" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "Kubernetes"
    organization = "Kubernetes"
    organizational_unit = "Kubernetes The Hard Way"
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
    common_name  = "Kubernetes"
    organization = "system:service-accounts"
    organizational_unit = "Kubernetes The Hard Way"
  }

  depends_on = [
    tls_private_key.ca,
    tls_self_signed_cert.ca,
  ]
}