terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"

    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

terraform {
  backend "s3" {
    bucket = "go-ecommerce-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}

resource "helm_release" "otel-collector"{
  name       = "otel-collector"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"

  set {
    name  = "mode"
    value = "deployment"
  }
  
    namespace = kubernetes_namespace.observability.metadata[0].name
}
