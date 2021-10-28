provider "google" {
  credentials = fileexists(var.gcp_key) ? file(var.gcp_key) : var.gcp_key
  project     = var.project
}


