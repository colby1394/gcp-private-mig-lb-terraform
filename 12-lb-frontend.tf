# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
# Resource: Reserve Regional Static IP Address
resource "google_compute_address" "lb" {
  name   = "lb-static-ip"
  region = "us-central1"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service
# Resource: Regional Backend Service
resource "google_compute_address" "lb-tokyo" {
  name         = "lb-address"
  region       = "asia-northeast1" # Tokyo region
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_backend_service

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_forwarding_rule
# Resource: Regional Forwarding Rule
resource "google_compute_forwarding_rule" "lb" {
  name                  = "lb-forwarding-rule"
  target                = google_compute_region_target_http_proxy.lb.self_link
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.lb.address
  load_balancing_scheme = "EXTERNAL_MANAGED" # Current Gen LB (not classic)
  network               = google_compute_network.main.id
  region                = "us-central1" # Iowa region

  # During the destroy process, we need to ensure LB is deleted first, before proxy-only subnet
  depends_on = [google_compute_subnetwork.regional_proxy_subnet]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager

#  toyo forwarding rule
resource "google_compute_forwarding_rule" "lb-tokyo" {
  name                  = "lb-forwarding-rule-tokyo"
  target                = google_compute_region_target_http_proxy.lb-tokyo.self_link
  network               = google_compute_network.main.id
  port_range            = "80"
  ip_protocol           = "TCP"
  ip_address            = google_compute_address.lb-tokyo.address
  load_balancing_scheme = "EXTERNAL_MANAGED" # Current Gen LB (not classic)
  region                = "asia-northeast1" # Tokyo region
  depends_on = [google_compute_subnetwork.tokyo_regional_proxy_subnet]
}
#  Resource URL Map Toyko 
resource "google_compute_region_url_map" "lb-tokyo" {
  name            = "lb-url-map-tokyo"
  default_service = google_compute_region_backend_service.lb-tokyo.self_link
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_url_map
# Resource: Regional URL Map
resource "google_compute_region_url_map" "lb" {
  name            = "lb-url-map"
  default_service = google_compute_region_backend_service.lb.self_link
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_target_http_proxy
# Resource: Regional HTTP Proxy
resource "google_compute_region_target_http_proxy" "lb" {
  name    = "lb-http-proxy"
  url_map = google_compute_region_url_map.lb.self_link
  region  = "us-central1" # Iowa region
}

# Tokyo HTTP Proxy
resource "google_compute_region_target_http_proxy" "lb-tokyo" {
  name    = "lb-http-proxy-tokyo"
  url_map = google_compute_region_url_map.lb-tokyo.self_link
  region  = "asia-northeast1" # Tokyo region
}