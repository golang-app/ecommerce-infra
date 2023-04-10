terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"

    }
  }
}

provider "kubernetes" {
  config_path = var.kube_config
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config
  }
}

terraform {
  backend "s3" {
    bucket = "go-ecommerce-state"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

module "observability" {
  source      = "./observability"
  kube_config = "~/.kube/config"
}