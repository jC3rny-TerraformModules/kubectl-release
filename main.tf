
locals {
  jsonnet_libs_path      = "${var.jsonnet_folder_path}/vendor"
  jsonnet_file_directory = "${var.jsonnet_folder_path}/${var.jsonnet_environment_folder_name}/${var.jsonnet_environment_subfolder_name}"
  jsonnet_files          = fileset(local.jsonnet_file_directory, "*.jsonnet")
  #
  kubectl_manifest_sensitive_fields = var.kubectl_manifest_sensitive_fields != null ? concat(["data"], var.kubectl_manifest_sensitive_fields) : null
}


# kubernetes server version
data "kubectl_server_version" "current" {}

# helm
data "helm_template" "release" {
  count = var.helm_chart_path != "" ? 1 : 0
  #
  chart = var.helm_chart_path
  #
  name      = var.helm_release_name
  namespace = var.helm_release_namespace
  #
  kube_version = data.kubectl_server_version.current.version
  #
  values = var.helm_chart_values
  #
  depends_on = [
    data.kubectl_server_version.current
  ]
}

data "kubectl_file_documents" "helm_template" {
  content = try(data.helm_template.release[0].manifest, "")
  #
  depends_on = [
    data.helm_template.release
  ]
}

resource "kubectl_manifest" "helm_template" {
  for_each = data.kubectl_file_documents.helm_template.manifests
  #
  yaml_body = each.value
  #
  sensitive_fields   = local.kubectl_manifest_sensitive_fields
  force_new          = var.kubectl_manifest_force_new
  server_side_apply  = var.kubectl_manifest_server_side_apply
  force_conflicts    = var.kubectl_manifest_force_conflicts
  apply_only         = var.kubectl_manifest_apply_only
  ignore_fields      = var.kubectl_manifest_ignore_fields
  override_namespace = var.kubectl_manifest_override_namespace
  #
  depends_on = [
    data.kubectl_file_documents.helm_template
  ]
}

# jsonnet
data "jsonnet_file" "release" {
  for_each = { for f in local.jsonnet_files : f => f if var.jsonnet_folder_path != "" }
  #
  source = var.jsonnet_file_path != "" ? var.jsonnet_file_path : "${local.jsonnet_file_directory}/${each.value}"
}

data "kubectl_file_documents" "jsonnet_file" {
  for_each = { for k, v in flatten([for obj in data.jsonnet_file.release : jsondecode(obj.rendered)]) : k => v }
  #
  content = yamlencode(each.value)
  #
  depends_on = [
    data.jsonnet_file.release
  ]
}

resource "kubectl_manifest" "jsonnet_file" {
  for_each = { for k, v in data.kubectl_file_documents.jsonnet_file : keys(v.manifests)[0] => lookup(v.manifests, keys(v.manifests)[0]) }
  #
  yaml_body = each.value
  #
  sensitive_fields   = local.kubectl_manifest_sensitive_fields
  force_new          = var.kubectl_manifest_force_new
  server_side_apply  = var.kubectl_manifest_server_side_apply
  force_conflicts    = var.kubectl_manifest_force_conflicts
  apply_only         = var.kubectl_manifest_apply_only
  ignore_fields      = var.kubectl_manifest_ignore_fields
  override_namespace = var.kubectl_manifest_override_namespace
  #
  depends_on = [
    data.kubectl_file_documents.jsonnet_file
  ]
}
