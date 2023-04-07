resource "helm_release" "otel-collector" {
  name = "otel-collector"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"

  set {
    name  = "mode"
    value = "deployment"
  }

  namespace = var.namespace
}