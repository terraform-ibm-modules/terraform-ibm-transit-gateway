##############################################################################
# Outputs
##############################################################################

output "tg_id" {
  description = "The ID of the transit gateway"
  value       = module.tg_gateway_connection.tg_id
}

output "filter_ids" {
  description = "Prefix filter IDs"
  value       = module.tg_gateway_connection.filter_ids
}