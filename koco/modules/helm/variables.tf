variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
  default = "ap-northeast-2"
}

variable "vpc_id" {
  type = string
}

variable "domain_name"{
  type = string
}

variable "acm_certificate_arn" {
  type = string
}