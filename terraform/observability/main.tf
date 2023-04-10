resource "kubernetes_namespace" "observability" {
  metadata {
    name = var.namespace
  }
}