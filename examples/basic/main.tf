module "argocd" {
  source = "../../"

  namespace = "argocd"
  domain    = "argocd.example.com"
}

output "admin_password_command" {
  value = module.argocd.admin_password_command
}

output "server_url" {
  value = module.argocd.server_url
}
