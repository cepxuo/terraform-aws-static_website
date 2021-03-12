#----------------------------------[Variables]----------------------------------

variable "region" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(any)
  default = {}
}

variable "project_name" {
  type    = string
  default = ""
}

variable "domain" {
  type    = string
  default = ""
}

variable "bucket" {
  type    = string
  default = ""
}

variable "log_bucket" {
  type    = string
  default = ""
}

variable "bucket_arn" {
  type    = string
  default = ""
}

variable "bucket_dn" {
  type    = string
  default = ""
}

variable "s3_origin_id" {
  type    = string
  default = ""
}

variable "cert_arn" {
  type    = string
  default = ""
}

variable "user_arn" {
  type    = string
  default = ""
}
