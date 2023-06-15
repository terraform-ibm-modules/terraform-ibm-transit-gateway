variable "transit_gateway_name" {
  description = "Name of the transit gateway to create. It can be null if existing_transit_gateway_name is not null"
  type        = string
  default     = null
}

variable "region" {
  description = "The IBM Cloud region where all resources are provisioned. It can be null if existing_transit_gateway_name is not null"
  type        = string
  default     = null
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

variable "existing_transit_gateway_name" {
  description = "Name of an existing transit gateway to connect VPCs. If null a new Transit Gateway will be created (transit_gateway_name and region required)"
  type        = string
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags"
  default     = null
}

variable "vpc_connections" {
  type        = list(string)
  description = "The list of vpc instance resource_crn to add network connections for."
}

variable "classic_connections_count" {
  type        = number
  description = "Number of classic connections to add."
}

variable "delete_timeout" {
  type        = string
  description = "Deleting timeout value of the ibm_tg_gateway"
  default     = "45m"
}
