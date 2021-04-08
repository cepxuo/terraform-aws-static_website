#----------------------------------[Variables]----------------------------------

variable "region" {
  description = "Default Region"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Common Tags"
  type        = map(any)
  default     = {}
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = ""
}

variable "bucket" {
  description = "S3 Bucket Name"
  type        = string
  default     = ""
}

variable "log_bucket" {
  description = "Bucket name to store logs"
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain Name"
  type        = string
  default     = ""
}

variable "spf" {
  description = "SPF Record"
  type        = list(string)
  default     = []
}

variable "dkim" {
  description = "DKIM Public Key"
  type        = list(string)
  default     = []
}

variable "dmarc" {
  description = "DMARC record"
  type        = list(string)
  default     = []
}

variable "mx" {
  description = "List of MX records"
  type        = list(string)
  default     = []
}



