variable "bootstrap_applicationset_enabled" {
  description = "Enable bootstrap ApplicationSet for automatic app discovery"
  type        = bool
  default     = false
}

variable "bootstrap_applicationset_name" {
  description = "Name of the bootstrap ApplicationSet"
  type        = string
  default     = "cluster-apps"
}

variable "bootstrap_repo_url" {
  description = "Git repository URL for bootstrap ApplicationSet"
  type        = string
  default     = ""
}

variable "bootstrap_repo_revision" {
  description = "Git revision for bootstrap ApplicationSet"
  type        = string
  default     = "HEAD"
}

variable "bootstrap_repo_path" {
  description = "Path pattern in repository for app discovery (e.g., apps/*)"
  type        = string
  default     = "apps/*"
}

variable "bootstrap_destination_server" {
  description = "Kubernetes API server URL for bootstrap apps"
  type        = string
  default     = "https://kubernetes.default.svc"
}

variable "bootstrap_project" {
  description = "ArgoCD project for bootstrap apps"
  type        = string
  default     = "default"
}

variable "bootstrap_sync_automated" {
  description = "Enable automated sync for bootstrap apps"
  type        = bool
  default     = false
}

variable "bootstrap_sync_prune" {
  description = "Enable pruning for automated sync"
  type        = bool
  default     = false
}

variable "bootstrap_sync_self_heal" {
  description = "Enable self-healing for automated sync"
  type        = bool
  default     = true
}

variable "bootstrap_create_namespace" {
  description = "Create namespace for each app automatically"
  type        = bool
  default     = true
}
