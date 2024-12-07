output "tg_id" {
  description = "The ID of the transit gateway"
  value       = local.transit_gateway_id
}

output "tg_crn" {
  description = "CRN of the gateway"
  value       = local.transit_gateway_crn
}

output "vpc_conn_ids" {
  description = "List of VPC connection IDs"
  value       = { for k, v in ibm_tg_connection.vpc_connections : v.network_id => v.connection_id }
}

output "classic_conn_ids" {
  description = "List of classic connection IDs"
  value       = { for k, v in ibm_tg_connection.classic_connections : v.network_id => v.connection_id }
}

# output "filter_ids" {
#   description = "Prefix filter IDs"
#   value       = ibm_tg_connection_prefix_filter.add_prefix_filter
# }
