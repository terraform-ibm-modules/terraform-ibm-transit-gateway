variable "ibmcloud_api_key" {
  description = "API key that is associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "The prefix to append to your resources"
  type        = string
}

variable "transit_gateway_name" {
  description = "Name of the transit gateway"
  type        = string
}

variable "region" {
  description = "Location of the transit gateway."
  type        = string
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example. If not set, a new resource group is created."
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags"
  default     = null
}
