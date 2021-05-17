variable "transit_gateway_name" {
  description = "Name of the transit gateway"
  type        = string
}

variable "location" {
  description = "Location of the transit gateway."
  type        = string
}

variable "global_routing" {
  description = "Gateways with global routing (true) to connect to the networks outside their associated region"
  type        = bool
  default     = false
}

variable "resource_group_id" {
  description = "Resource group ID where the transit gateway to be created."
  type        = string
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "List of tags"
  default     = null
}

variable "vpc_connections" {
  type        = list(string)
  description = "The list of vpc instance resource_crn to add network connections for."
}

variable "classic_connnections_count" {
  type        = number
  description = "Number of classic connections to add."
}

