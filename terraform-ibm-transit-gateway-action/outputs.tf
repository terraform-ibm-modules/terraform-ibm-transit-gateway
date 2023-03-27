output "vpc_tg_crossaacount_approvals" {
  description = "Result for vpc crossaccount actions"
  value       = toset(vpc_tg_cross_connection_approval[*])
}

output "classic_tg_crossaacount_approvals" {
  description = "Result for classic crossaccount actions"
  value       = toset(classic_tg_cross_connection_approval[*])
}
