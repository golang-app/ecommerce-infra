variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "jaeger_operator_chart_version" {
  type    = string
  default = "2.23.1"
}