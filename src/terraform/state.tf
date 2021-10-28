terraform {
  backend "gcs" {
    bucket = "terraform-gcp-vault-unseal"
    prefix = "terraform/state"
  }
}
