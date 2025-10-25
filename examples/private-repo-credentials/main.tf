module "argocd" {
  source = "helmcode.scalr.io/environment-a/argocd/k8s"

  domain        = "argocd.example.com"
  namespace     = "argocd"
  chart_version = "7.6.12"

  # Enable repository credentials for private repos
  repository_credentials_enabled = var.repository_credentials_enabled
  repository_url                 = var.repository_url
  repository_username            = var.repository_username
  repository_password            = var.repository_password
  repository_name                = var.repository_name
}

# Variables that can be configured in Scalr UI or passed via environment
variable "repository_credentials_enabled" {
  description = "Enable repository credentials"
  type        = bool
  default     = true
}

variable "repository_url" {
  description = "Repository URL (e.g., https://gitlab.helmcode.com)"
  type        = string
}

variable "repository_username" {
  description = "Repository username (e.g., 'gitlab-ci-token' for GitLab)"
  type        = string
  default     = "gitlab-ci-token"
}

variable "repository_password" {
  description = "Repository token or password. Set in Scalr as SENSITIVE variable or via TF_VAR_repository_password"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "Name identifier for this credential"
  type        = string
  default     = "default-repo"
}
