variable "ibmcloud_api_key" {
  description = "API key that is associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "transit_gateway_name" {
  description = "Name of the transit gateway"
  type        = string
}

variable "region" {
  description = "The IBM Cloud region where all resources are provisioned."
  type        = string
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example. If not set, a new resource group is created."
  default     = null
}

variable "prefix" {
  description = "The prefix to append to your resources"
  type        = string
  default     = "tg"
}

variable "global_routing" {
  description = "Gateways with global routing (true) to connect to the networks outside their associated region"
  type        = bool
  default     = false
}

variable "vpc_connections" {
  type        = list(string)
  description = "The list of vpc instance resource_crn to add network connections for."
}

variable "classic_connections_count" {
  type        = number
  description = "Number of classic connections to add."
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags"
  default     = null
}
