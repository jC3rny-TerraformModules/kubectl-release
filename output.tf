
output "helm_template_manifests" {
  value = var.helm_chart_path != "" ? data.kubectl_file_documents.helm_template.manifests : null
}

output "jsonnet_files" {
  value = var.jsonnet_folder_path != "" ? [ for f in local.jsonnet_files : f ] : null
}

output "jsonnet_file_release" {
  value = var.jsonnet_folder_path != "" ? flatten([ for obj in data.jsonnet_file.release : jsondecode(obj.rendered) ]) : null
}

output "jsonnet_file_documents" {
  value = var.jsonnet_folder_path != "" ? data.kubectl_file_documents.jsonnet_file : null
}

output "jsonnet_file_manifests" {
  value = var.jsonnet_folder_path != "" ? { for k, v in data.kubectl_file_documents.jsonnet_file : keys(v.manifests)[0] => lookup(v.manifests, keys(v.manifests)[0]) } : null
}
