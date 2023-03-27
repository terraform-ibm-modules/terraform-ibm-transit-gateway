resource "ibm_tg_gateway" "vpc_tg_cross_connection_approval" {
  for_each      = toset(var.vpc_connection_ids)
  provider      = ibm.cross_connection_approver
  gateway       = var.transit_gw_id
  connection_id = each.value
  action        = var.action
}

resource "ibm_tg_gateway" "classic_tg_cross_connection_approval" {
  for_each      = toset(var.classic_connection_ids)
  provider      = ibm.cross_connection_approver
  gateway       = var.transit_gw_id
  connection_id = each.value
  action        = var.action
}
