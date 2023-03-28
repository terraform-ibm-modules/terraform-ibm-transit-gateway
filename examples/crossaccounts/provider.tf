# provider for account A
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_a # pragma: allowlist secret - API key with access to RIAS APIs
  region           = var.region_a
  alias            = "accountA"
}

# provider for account B
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_b # pragma: allowlist secret - API key with access to RIAS APIs
  region           = var.region_b
  alias            = "accountB"
}
