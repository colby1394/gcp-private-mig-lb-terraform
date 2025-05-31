resource "google_compute_subnetwork" "hqinternal" {
  name                     = "hqinternal"
  ip_cidr_range            = "10.100.10.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "tokyointernal" {
  name                     = "toykointernal"
  ip_cidr_range            = "10.100.50.0/24"
  region                   = "asia-northeast1"
  # This is the Tokyo region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}


# Regional Proxy-Only Subnet 
# Required for Regional Application Load Balancer for traffic offloading
resource "google_compute_subnetwork" "regional_proxy_subnet" {
  name          = "regional-proxy-subnet"
  region        = "us-central1"
  ip_cidr_range = "10.0.0.0/24"
  purpose       = "REGIONAL_MANAGED_PROXY"
  network       = google_compute_network.main.id
  role          = "ACTIVE"
}

# Regional Proxy-Only Subnet for Tokyo
# # Required for Regional Application Load Balancer for traffic offloading
resource "google_compute_subnetwork" "tokyo_regional_proxy_subnet" {
  name          = "regional-proxy-subnet"
  region        = "asia-northeast1"
  ip_cidr_range = "10.0.10.0/24"
  purpose       = "REGIONAL_MANAGED_PROXY"
  network       = google_compute_network.main.id
  role          = "ACTIVE"
}



