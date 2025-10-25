variable "repository_credentials_enabled" {
  description = "Enable repository credentials configuration in ArgoCD"
  type        = bool
  default     = false
}

variable "repository_url" {
  description = "URL of the private Git repository"
  type        = string
  default     = "https://gitlab.helmcode.com"
}

variable "repository_username" {
  description = "Username for repository authentication)"
  type        = string
  default     = "gitlab-ci-token"
}

variable "repository_password" {
  description = "Password or token for repository authentication. Set as sensitive variable in Scalr or environment variable TF_VAR_repository_password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "repository_name" {
  description = "Name identifier for this repository credential (optional, will use 'default-repo' if not provided)"
  type        = string
  default     = ""
}

variable "repository_type" {
  description = "Type of repository (git, helm)"
  type        = string
  default     = "git"
}
