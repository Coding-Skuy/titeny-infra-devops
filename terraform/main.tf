terraform {
  required_version = "1.9.8"
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "2.32.0" }
  }
}

variable "namespace" { default = "titeny" }

resource "kubernetes_namespace" "titeny" {
  metadata { name = var.namespace }
}
