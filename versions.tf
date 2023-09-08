
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    jsonnet = {
      source  = "alxrem/jsonnet"
      version = "2.2.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.2"
    }
  }

  required_version = ">= 1.4.0"
}
