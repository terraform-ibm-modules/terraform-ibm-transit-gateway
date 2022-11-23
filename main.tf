resource "ibm_tg_gateway" "tg_gw_instance" {
  name           = var.transit_gateway_name
  location       = var.region
  global         = var.global_routing != null ? var.global_routing : false
  resource_group = var.resource_group_id != null ? var.resource_group_id : null
  tags           = var.resource_tags != null ? var.resource_tags : null
}

resource "ibm_tg_connection" "vpc_connections" {
  count = length(var.vpc_connections)

  gateway      = ibm_tg_gateway.tg_gw_instance.id
  network_type = "vpc"
  name         = "vpc_conn_inst${count.index}"
  network_id   = var.vpc_connections[count.index]
}

resource "ibm_tg_connection" "classic_connections" {
  count = var.classic_connections_count

  gateway      = ibm_tg_gateway.tg_gw_instance.id
  network_type = "classic"
  name         = "classic_conn_inst${count.index}"
}
