variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "The prefix to append to your resources"
  type        = string
  default     = "tg"
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
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags"
  default     = null
}

variable "vpc1_name" {
  type        = string
  description = "Name of the first VPC"
  default     = "vpc1"
}

variable "vpc2_name" {
  type        = string
  description = "Name of the second VPC"
  default     = "vpc2"
}
