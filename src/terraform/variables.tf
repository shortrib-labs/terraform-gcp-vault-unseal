variable "project" {
  description = "Google project name"
}

variable "region" {
  default = "us-east1"
}

variable "gcp_key" {
  description = "Path to (or contents of) GCP service account key"
}

variable "key_ring" {
  description = "Cloud KMS key ring name to create"
  default     = "test"
}

variable "crypto_key" {
  default     = "vault-test"
  description = "Crypto key name to create under the key ring"
}

variable "location" {
  default = "global"
}
