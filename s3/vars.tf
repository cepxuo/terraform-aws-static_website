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

variable "bucket" {
  type    = string
  default = ""
}

variable "log_bucket" {
  type    = string
  default = ""
}

variable "user_id" {
  type    = string
  default = ""
}
