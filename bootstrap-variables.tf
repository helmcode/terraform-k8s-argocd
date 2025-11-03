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

variable "bootstrap_destination" {
  description = "Set of applicationSets for clusters management"
  type = map(object({
    path = string
    revision = string
    project = string
    server = string
  }))
  default = {
    "default" = {
      path = "apps/*"
      revision = "HEAD"
      project = "default"
      server = "in-cluster"
    }
  }
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
