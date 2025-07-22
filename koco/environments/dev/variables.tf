variable "region" {
  type = string
  default = "ap-northeast-2"
  description = "AWS Region"
}
variable "stage" {
  type = string
  default = "dev"
}
variable "servicename" {
  type = string
  default = "koco"
}

#VPC
variable "vpc_tags" {
  type = map(string)
  default = {
    "name" = "koco-VPC"
  }
}
variable "az" {
  type = list(any)
  default = [ "ap-northeast-2a",
              "ap-northeast-2c"]
}
variable "vpc_ip_range" {
  type = string
  default = "10.110.0.0/16"
}
variable "subnet_public_az1" {
  type = string
  default = "10.110.110.0/24"
}
variable "subnet_public_az2" {
  type = string
  default = "10.110.120.0/24"
}
variable "subnet_service_az1" {
  type = string
  default = "10.110.130.0/24"
}
variable "subnet_service_az2" {
  type = string
  default = "10.110.140.0/24"
}
variable "subnet_db_az1" {
  type = string
  default = "10.110.150.0/24"
}
variable "subnet_db_az2" {
  type = string
  default = "10.110.160.0/24"
}

#openvpn
variable "openvpn_tags" {
  type = map(string)
  default = {
    "name" = "koco-openvpn"
  }
}

#db
variable "db_tags" {
  type = map(string)
  default = {
    "name" = "koco-db"
  }
}
variable "db_ip" {
  type = string
  default = "10.110.150.100"
}

#helm
variable "domain_name" {
  type = string
  default = ""
}

variable "acm_certificate_arn" {
  type = string
  default = ""
}

#s3-static-site
variable "s3-static-bucket-name" {
  type = string
  default = "prod-koco-front-s3"
}