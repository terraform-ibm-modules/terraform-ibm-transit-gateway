variable "ibmcloud_api_key" {
  description = "APIkey entitled to perform the action on the transit gateway external account connection"
  type        = string
}

variable "vpc_connection_ids" {
  type        = list(string)
  description = "The list of vpc connection IDs to perform the action for the account owner of ibmcloud_api_key"
}

variable "classic_connection_ids" {
  type        = list(string)
  description = "The list of classic connection IDs to perform the action for the account owner of ibmcloud_api_key"
}

variable "transit_gw_id" {
  type        = string
  description = "ID to the transit gateway where the cross-account connection is created"
}

variable "action" {
  type        = string
  description = "Action to peform on the list of cnnection ids. Allowed values are 'approve' or 'reject'"
  validation {
    condition     = contains(["approve", "reject"], var.action)
    error_message = "Valid values for var: action are (approve, reject)."
  }
}
