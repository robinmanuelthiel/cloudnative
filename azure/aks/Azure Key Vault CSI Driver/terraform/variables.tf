variable "prefix" {
  description = "Name that should be prepended to every resource"
  default     = "rothiekvcsi"
  type        = string
}

variable "location" {
  description = "Location of the Azure Resource Group"
  default     = "westeurope"
  type        = string
}
