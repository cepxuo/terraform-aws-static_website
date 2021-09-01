#----------------------------------[Variables]----------------------------------

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
