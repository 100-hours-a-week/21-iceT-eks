variable "bucket_name" {
  description = "Frontend static hosting bucket name"
  type        = string
}
variable "cloudfront_oai_arn" {
  description = "CloudFront Origin Access Identity의 IAM ARN"
  type        = string
}
