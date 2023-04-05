resource "ibm_tg_connection_action" "vpc_tg_cross_connection_approval" {
  for_each      = { for i, val in var.vpc_connection_ids : i => val }
  gateway       = var.transit_gw_id
  connection_id = each.value
  action        = var.action
}

resource "ibm_tg_connection_action" "classic_tg_cross_connection_approval" {
  for_each      = { for i, val in var.classic_connection_ids : i => val }
  gateway       = var.transit_gw_id
  connection_id = each.value
  action        = var.action
}
