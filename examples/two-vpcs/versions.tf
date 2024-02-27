terraform {
  required_version = ">= 1.0.0, <1.7.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.52.0"
    }
  }
}
