provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key # pragma: allowlist secret - API key with access to RIAS APIs
  region           = var.ibm_region
  alias            = "cross_connection_approver"
}
