# provider for account A
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_a # pragma: transit gateway account owner apikey
  region           = var.region_a
  alias            = "accountA"
}

# provider for account B
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_b # pragma: external account apikey
  region           = var.region_b
  alias            = "accountB"
}
