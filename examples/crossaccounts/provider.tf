# provider for account A
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key # pragma: transit gateway account owner apikey
  region           = var.region_a
  alias            = "accountA"
}

# provider for account B
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_ext # pragma: external account apikey
  region           = var.region_b
  alias            = "accountB"
}
