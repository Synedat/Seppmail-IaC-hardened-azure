variable "resource_group_name" {
  type        = string
  description = "Azure resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "westeurope"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for created resources"
  default     = "seppmail"
}

variable "smtp_allowed_sources" {
  type        = list(string)
  description = "Approved SMTP source IP ranges"
  default     = ["0.0.0.0/32"]
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    workload = "seppmail"
    owner    = "synedat"
  }
}
