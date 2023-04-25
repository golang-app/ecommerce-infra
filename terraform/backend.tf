terraform {
  backend "s3" {
    bucket = "go-ecommerce-state"
    key    = "ecommerce-infra.tfstate"
    region = "eu-central-1"
  }
}