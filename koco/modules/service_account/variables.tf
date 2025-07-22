variable "sa-name"{
  type = string
  default = "aws-load-balancer-controller"
}

variable "sa-namespace"{
  type = string
  default = "kube-system"
}

variable "sa-annotations" {
  type = map(string)
  default = {
    "eks.amazonaws.com/role-arn" = ""
  }
}
