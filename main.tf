locals {
  transit_gateway_id  = var.existing_transit_gateway_name != null ? data.ibm_tg_gateway.existing_tg_gw_instance[0].id : ibm_tg_gateway.tg_gw_instance[0].id
  transit_gateway_crn = var.existing_transit_gateway_name != null ? data.ibm_tg_gateway.existing_tg_gw_instance[0].crn : ibm_tg_gateway.tg_gw_instance[0].crn
}

data "ibm_tg_gateway" "existing_tg_gw_instance" {
  count = var.existing_transit_gateway_name != null ? 1 : 0
  name  = var.existing_transit_gateway_name
}

resource "ibm_tg_gateway" "tg_gw_instance" {
  count          = var.existing_transit_gateway_name != null ? 0 : 1
  name           = var.transit_gateway_name
  location       = var.region
  global         = var.global_routing != null ? var.global_routing : false
  resource_group = var.resource_group_id != null ? var.resource_group_id : null
  tags           = var.resource_tags != null ? var.resource_tags : null
  timeouts {
    delete = var.delete_timeout
  }
}

resource "ibm_tg_connection" "vpc_connections" {
  count = length(var.vpc_connections)

  gateway               = local.transit_gateway_id
  network_type          = "vpc"
  name                  = "vpc_conn_inst${count.index}"
  network_id            = var.vpc_connections[count.index]
  default_prefix_filter = var.default_prefix_filter
}
# locals {
#   filter_map = flatten([
#     for conn in ibm_tg_connection.vpc_connections :
#     flatten([
#       for key, filter in var.add_prefix_filters :
#       {
#         for obj in filter :
#         (key) => merge(obj, { connection_id = conn.connection_id
#         gateway = conn.gateway })... if key == conn.network_id
#       }
#     ])
#     # conn.network_id => conn
#   ])

#   #  secondary_reserved_ips_map = {
#   #     for key,ip in local.filter_map :
#   #     key => ip
#   #   }

#   secondary_reserved_ips_intermediate = merge([
#     for test in local.filter_map :

#     test

#   ]...)

#   final_map = flatten([
#     for key, value in local.secondary_reserved_ips_intermediate :
#     value
#   ])
# }

locals {
  filter_list = flatten([
    for conn in ibm_tg_connection.vpc_connections :
    [
      for filter in var.add_prefix_filters :
      merge(filter, { connection_id = conn.connection_id
      gateway = conn.gateway }) if filter.connection == conn.network_id
    ]
  ])
}
output "tg_conn_vpc_connections" {
  value = ibm_tg_connection.vpc_connections
}

output "vpc_conn_list" {
  value = var.vpc_connections
}

output "map" {
  value = local.filter_list
}
resource "ibm_tg_connection" "classic_connections" {
  count = var.classic_connections_count

  gateway               = local.transit_gateway_id
  network_type          = "classic"
  name                  = "classic_conn_inst${count.index}"
  default_prefix_filter = var.default_prefix_filter
}


resource "ibm_tg_connection_prefix_filter" "add_prefix_filter" {
  count = length(var.add_prefix_filters) > 0 ? length(var.add_prefix_filters) : 0
  # for_each      = local.final_map
  gateway       = local.filter_list[count.index].gateway       #ibm_tg_gateway.tg_gw_instance[0].id
  connection_id = local.filter_list[count.index].connection_id #ibm_tg_connection.vpc_connections[count.index].connection_id
  action        = local.filter_list[count.index].action
  prefix        = local.filter_list[count.index].prefix
  le            = local.filter_list[count.index].le
  ge            = local.filter_list[count.index].ge
}
