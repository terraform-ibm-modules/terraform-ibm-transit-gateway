# provider for account A
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_account_a # pragma: transit gateway account owner apikey
  region           = var.region_account_a
  alias            = "accountA"
}

# provider for account B
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key_account_b # pragma: external account apikey
  region           = var.region_account_b
  alias            = "accountB"
}
