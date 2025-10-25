output "namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.argocd.name
}

output "release_status" {
  description = "Status of the Helm release"
  value       = helm_release.argocd.status
}

output "chart_version" {
  description = "ArgoCD chart version deployed"
  value       = helm_release.argocd.version
}

output "admin_password_command" {
  description = "Command to retrieve ArgoCD admin password"
  value       = "kubectl -n ${var.namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "service_info_command" {
  description = "Command to get ArgoCD server service information"
  value       = "kubectl -n ${var.namespace} get svc ${var.release_name}-server"
}

output "server_url" {
  description = "ArgoCD server URL (domain-based)"
  value       = var.insecure_mode ? "http://${var.domain}" : "https://${var.domain}"
}
