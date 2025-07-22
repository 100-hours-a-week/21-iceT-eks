variable "role-alc_role_name"{
  type = string
  default = "alb-ingress-sa-role"
}

variable "role-alc-oidc_without_https"{
  type = string
}

variable "role-alc-namespace"{
  type = string
}

variable "role-alc-sa_name"{
  type = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC Provider ARN"
  type        = string
}

variable "oidc_url_without_https" {
  description = "EKS OIDC Issuer URL without https://"
  type        = string
}