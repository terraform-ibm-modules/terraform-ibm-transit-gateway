##############################################################################
# Outputs
##############################################################################

output "tg_id" {
  description = "The ID of the transit gateway"
  value       = module.tg_gateway_connection.tg_id
}

# output "filter_ids" {
#   description = "Prefix filter IDs"
#   value       = module.tg_gateway_connection.filter_ids
# }

output "conn_vpc_id" {
  value = module.tg_gateway_connection.tg_conn_vpc_connections
}

output "var_conn" {
  value = module.tg_gateway_connection.vpc_conn_list
}

output "map" {
  value = module.tg_gateway_connection.map
}