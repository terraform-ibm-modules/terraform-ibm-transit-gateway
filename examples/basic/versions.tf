terraform {
  required_version = ">= 1.0.0, <1.7.0"
  # Ensure that there is always 1 example locked into the lowest provider version of the range defined in the main
  # module's version.tf (basic), and 1 example that will always use the latest provider version.
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.52.0"
    }
  }
}
