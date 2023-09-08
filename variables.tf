
# kubernetes
variable "kubernetes_config_path" {
  type    = string
  default = ""
}

# helm_chart
variable "helm_chart_path" {
  type    = string
  default = ""
}
variable "helm_chart_values" {
  type    = list(string)
  default = []
}
variable "helm_release_name" {
  type    = string
  default = ""
}
variable "helm_release_namespace" {
  type    = string
  default = ""
}

# jsonnet
variable "jsonnet_folder_path" {
  type    = string
  default = ""
}
variable "jsonnet_libs_path" {
  type    = string
  default = ""
}

variable "jsonnet_file_path" {
  type    = string
  default = ""
}

variable "jsonnet_environment_folder_name" {
  type    = string
  default = "environments"
}

variable "jsonnet_environment_subfolder_name" {
  type    = string
  default = ""
}

# kubectl_manifest
variable "kubectl_manifest_sensitive_fields" {
  type    = list(string)
  default = null
}

variable "kubectl_manifest_force_new" {
  type    = bool
  default = false
}

variable "kubectl_manifest_server_side_apply" {
  type    = bool
  default = false
}

variable "kubectl_manifest_force_conflicts" {
  type    = bool
  default = false
}

variable "kubectl_manifest_apply_only" {
  type    = bool
  default = false
}

variable "kubectl_manifest_ignore_fields" {
  type    = list(string)
  default = null
}

variable "kubectl_manifest_override_namespace" {
  type    = string
  default = ""
}
