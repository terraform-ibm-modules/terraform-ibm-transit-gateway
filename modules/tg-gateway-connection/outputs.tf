output "tg_id" {
  description = "The ID of the transit gateway"
  value       = ibm_tg_gateway.tg_gw_instance.id
}

output "tg_crn" {
  description = "CRN of the gateway"
  value       = ibm_tg_gateway.tg_gw_instance.crn
}

output "vpc_conn_ids" {
  description = "List of vpc connection IDs"
  value       = ibm_tg_connection.vpc_connections[*].connection_id
}

output "classic_conn_ids" {
  description = "List of classic connection IDs"
  value       = ibm_tg_connection.classic_connections[*].onnection_id
}
