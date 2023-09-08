# helm
provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}

# jsonnet
provider "jsonnet" {
  jsonnet_path = var.jsonnet_libs_path!= "" ? var.jsonnet_libs_path : local.jsonnet_libs_path
}

# kubectl
provider "kubectl" {
  config_path = var.kubernetes_config_path
}
