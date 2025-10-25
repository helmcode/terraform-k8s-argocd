variable "namespace" {
  description = "Namespace where ArgoCD will be deployed"
  type        = string
  default     = "argocd"
}

variable "create_namespace" {
  description = "Create the namespace if it doesn't exist"
  type        = bool
  default     = true
}

variable "namespace_labels" {
  description = "Additional labels for the namespace"
  type        = map(string)
  default     = {}
}

variable "namespace_annotations" {
  description = "Annotations for the namespace"
  type        = map(string)
  default     = {}
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.6.12"
}

variable "domain" {
  description = "Domain for ArgoCD"
  type        = string
}

variable "service_type" {
  description = "Kubernetes service type for ArgoCD server"
  type        = string
  default     = "LoadBalancer"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Service type must be ClusterIP, NodePort, or LoadBalancer"
  }
}

variable "service_annotations" {
  description = "Annotations for the ArgoCD server service"
  type        = map(string)
  default     = {}
}

variable "server_replicas" {
  description = "Number of ArgoCD server replicas"
  type        = number
  default     = 2
}

variable "server_resources" {
  description = "Resource limits and requests for ArgoCD server"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "controller_replicas" {
  description = "Number of ArgoCD application controller replicas"
  type        = number
  default     = 1
}

variable "controller_resources" {
  description = "Resource limits and requests for ArgoCD application controller"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "repo_server_replicas" {
  description = "Number of ArgoCD repo server replicas"
  type        = number
  default     = 2
}

variable "repo_server_resources" {
  description = "Resource limits and requests for ArgoCD repo server"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
    requests = {
      cpu    = "250m"
      memory = "256Mi"
    }
  }
}

variable "redis_enabled" {
  description = "Enable Redis for caching"
  type        = bool
  default     = true
}

variable "redis_resources" {
  description = "Resource limits and requests for Redis"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "dex_enabled" {
  description = "Enable Dex for SSO"
  type        = bool
  default     = false
}

variable "applicationset_enabled" {
  description = "Enable ApplicationSet controller"
  type        = bool
  default     = true
}

variable "applicationset_replicas" {
  description = "Number of ApplicationSet controller replicas"
  type        = number
  default     = 1
}

variable "applicationset_resources" {
  description = "Resource limits and requests for ApplicationSet controller"
  type = object({
    limits = object({
      cpu    = string
      memory = string
    })
    requests = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
  }
}

variable "notifications_enabled" {
  description = "Enable notifications controller"
  type        = bool
  default     = false
}

variable "insecure_mode" {
  description = "Run ArgoCD server in insecure mode (without TLS)"
  type        = bool
  default     = true
}

variable "ingress_enabled" {
  description = "Enable ingress for ArgoCD server"
  type        = bool
  default     = false
}

variable "ingress_class_name" {
  description = "Ingress class name"
  type        = string
  default     = "nginx"
}

variable "ingress_annotations" {
  description = "Annotations for the ingress"
  type        = map(string)
  default     = {}
}

variable "ingress_hosts" {
  description = "Ingress hosts"
  type        = list(string)
  default     = []
}

variable "ingress_tls" {
  description = "Ingress TLS configuration"
  type = list(object({
    secretName = string
    hosts      = list(string)
  }))
  default = []
}

variable "config_params" {
  description = "Additional config params for ArgoCD"
  type        = map(string)
  default     = {}
}

variable "extra_values" {
  description = "Extra values to merge with generated values (as YAML strings)"
  type        = list(string)
  default     = []
}

variable "helm_sets" {
  description = "Additional helm set values"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "helm_sets_sensitive" {
  description = "Additional sensitive helm set values"
  type = list(object({
    name  = string
    value = string
    type  = optional(string)
  }))
  default = []
}

variable "timeout" {
  description = "Timeout for Helm release operations"
  type        = number
  default     = 600
}

variable "wait" {
  description = "Wait for all resources to be ready"
  type        = bool
  default     = true
}

variable "force_update" {
  description = "Force resource update through delete/recreate if needed"
  type        = bool
  default     = true
}

variable "cleanup_on_fail" {
  description = "Cleanup resources on failed install"
  type        = bool
  default     = true
}
