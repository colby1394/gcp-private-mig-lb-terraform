# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
resource "google_compute_router" "iowa" {
  name    = "iowa-router"
  region  = "us-central1"
  network = google_compute_network.main.id
}

resource "google_compute_router" "tokyo" {
  name    = "tokyo-router"
  region  = "asia-northeast1"
  network = google_compute_network.main.id
}
