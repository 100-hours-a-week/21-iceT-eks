variable "tags"{
  type = map(string)
}
variable "stage" {
  type = string
}
variable "servicename" {
  type = string
}

variable "key_pair_name" {
  description = "인스턴스 키페어"
  type        = string
  default     = ""
}

variable "security_group_db_sg_id" {
  description = "db 보안 그룹 ID"
  type        = string
}

variable "subnet_private_id" {
  description = "인스턴스가 생성될 프라이빗 서브넷 ID"
  type        = string
}

variable "ip" {
  description = "인스턴스에 부여될 고정 ip"
  type        = string
}