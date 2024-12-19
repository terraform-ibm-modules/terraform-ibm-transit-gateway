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

variable "default_prefix_filter" {
  type        = string
  description = "Adjust the default filter. By default accepts all prefixes after entries in the prefix filter list are processed. Deny prefixes denies all prefixes after entries in the prefix filter list are processed. See https://cloud.ibm.com/docs/transit-gateway?topic=transit-gateway-adding-prefix-filters&interface=ui"
  validation {
    condition     = contains(["permit", "deny"], var.default_prefix_filter)
    error_message = "Valid values to set default prefix filter is `permit` or `deny`"
  }
  default = "permit"
}

variable "add_prefix_filters" {
  description = "Map of VPC CRN to optionally add prefix filter to set an ordered list of filters that determine the routes that transit gateway should accept or deny. Connections are denied or permitted based on the order of the filters passed. See https://cloud.ibm.com/docs/transit-gateway?topic=transit-gateway-adding-prefix-filters&interface=ui"
  type = list(object({
    action     = string
    prefix     = string
    le         = optional(number)
    ge         = optional(number)
    before     = optional(string)
    connection = string
  }))
  validation {
    condition = alltrue([
      for filter in var.add_prefix_filters :
      filter.le >= 0 && filter.le <= 32 && filter.ge >= 0 && filter.ge <= 32
    ])
    error_message = "Both 'le' and 'ge' must be between 0 and 32."
  }
  validation {
    condition = alltrue([
      for filter in var.add_prefix_filters :
      filter.action == "permit" || filter.action == "deny"
    ])
    error_message = "Valid values for 'action' are 'permit' or 'deny'."
  }
  default = []
}
