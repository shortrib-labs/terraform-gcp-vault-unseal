resource "google_service_account" "vault_kms_service_account" {
  account_id   = "vault-unseal"
  display_name = "Vault KMS for auto-unseal"
}

resource "google_service_account_key" "vault_kms_service_account" {
  service_account_id = google_service_account.vault_kms_service_account.name
}

# Create a KMS key ring
resource "google_kms_key_ring" "key_ring" {
  project  = var.project
  name     = var.key_ring
  location = var.location
}

# Create a crypto key for the key ring
resource "google_kms_crypto_key" "crypto_key" {
  name            = var.crypto_key
  key_ring        = google_kms_key_ring.key_ring.self_link
  rotation_period = "100000s"
}

# Add the service account to the Keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role        = "roles/owner"

  members = [
    "serviceAccount:${google_service_account.vault_kms_service_account.email}",
  ]
}

output "service_account_key" {
  value     = google_service_account_key.vault_kms_service_account.private_key
  sensitive = true
}
