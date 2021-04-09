#----------------------------------[Variables]----------------------------------

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

variable "prov" {
  type    = string
  default = ""
}

variable "cloudfront_zone_id" {
  type    = string
  default = ""
}

variable "cloudfront_domain_name" {
  type    = string
  default = ""
}

variable "spf" {
  type    = list(string)
  default = []
}

variable "dkim" {
  type    = list(string)
  default = []
}

variable "dmarc" {
  type    = list(string)
  default = []
}

variable "mx" {
  type    = list(string)
  default = []
}
