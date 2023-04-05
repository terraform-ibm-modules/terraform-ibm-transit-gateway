# variables Account A

variable "ibmcloud_api_key_account_a" {
  description = "API key that is associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "prefix_account_a" {
  description = "The prefix to append to your resources"
  type        = string
  default     = "tg-cross-a"
}

variable "transit_gateway_name" {
  description = "Name of the transit gateway"
  type        = string
  default     = "crosstg-gw"
}

variable "region_account_a" {
  description = "Location of the transit gateway"
  type        = string
}

variable "resource_group_account_a" {
  type        = string
  description = "An existing resource group name to use for this example. If not set, a new resource group is created."
  default     = null
}

variable "resource_tags_account_a" {
  type        = list(string)
  description = "List of tags"
  default     = []
}

variable "vpc_name_account_a" {
  type        = string
  description = "Name of the first VPC in the first account"
  default     = "vpc-a"
}

# variables Account B

variable "ibmcloud_api_key_account_b" {
  description = "API key that is associated with the account to provision resources to"
  type        = string
  sensitive   = true
}

variable "prefix_account_b" {
  description = "The prefix to append to your resources"
  type        = string
  default     = "tg-cross-b"
}

variable "region_account_b" {
  description = "Location of the transit gateway."
  type        = string
}

variable "resource_group_account_b" {
  type        = string
  description = "An existing resource group name to use for this example. If not set, a new resource group is created."
  default     = null
}

variable "resource_tags_account_b" {
  type        = list(string)
  description = "List of tags"
  default     = []
}

variable "vpc_name_account_b" {
  type        = string
  description = "Name of the second VPC on second account"
  default     = "vpc-b"
}

variable "existing_vpc_crn_account_b" {
  type        = string
  description = "Account b existing vpc crn for crossaccount test"
  default     = null
}
