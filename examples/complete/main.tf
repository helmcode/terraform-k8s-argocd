module "argocd" {
  source = "../../"

  namespace     = "argocd"
  chart_version = "7.6.12"
  domain        = "argocd.example.com"
  service_type  = "ClusterIP"
  insecure_mode = false

  server_replicas      = 3
  controller_replicas  = 2
  repo_server_replicas = 2

  server_resources = {
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  controller_resources = {
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  ingress_enabled    = true
  ingress_class_name = "nginx"
  ingress_annotations = {
    "cert-manager.io/cluster-issuer"           = "letsencrypt-prod"
    "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
  }
  ingress_hosts = ["argocd.example.com"]
  ingress_tls = [
    {
      secretName = "argocd-tls"
      hosts      = ["argocd.example.com"]
    }
  ]

  dex_enabled           = true
  notifications_enabled = true

  config_params = {
    "server.repo.server.timeout.seconds" = "120"
  }
}

output "namespace" {
  value = module.argocd.namespace
}

output "admin_password_command" {
  value = module.argocd.admin_password_command
}

output "server_url" {
  value = module.argocd.server_url
}
