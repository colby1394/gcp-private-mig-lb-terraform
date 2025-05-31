# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones
# Datasource: Get a list of Google Compute zones that are UP in a region
data "google_compute_zones" "available" {
  status = "UP"
  region = "us-central1" # Iowa region
}
data "google_compute_zones" "availabletokyo" {
  status = "UP"
  region = "asia-northeast1" # Tokyo region
}
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_region_instance_group_manager
# Resource: Managed Instance Group
resource "google_compute_region_instance_group_manager" "app" {
  depends_on         = [google_compute_router_nat.iowa]
  name               = "app-mig"
  base_instance_name = "app"
  #region = "" (optional if provider default is set)
  region = "us-central1" # Iowa region

  # Compute zones to be used for VM creation
  distribution_policy_zones = data.google_compute_zones.available.names

  # Instance Template
  version {
    instance_template = google_compute_region_instance_template.app.id
  }

  # Named Port
  named_port {
    name = "webserver"
    port = 80
  }

  # Autohealing Config
  auto_healing_policies {
    health_check      = google_compute_region_health_check.app.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_instance_group_manager" "app-tokyo" {
  depends_on         = [google_compute_router_nat.tokyo]
  name               = "app-mig-tokyo"
  base_instance_name = "app-tokyo"
  #region = "" (optional if provider default is set)
  region = "asia-northeast1" # Tokyo region

  # Compute zones to be used for VM creation
  distribution_policy_zones = data.google_compute_zones.availabletokyo.names

  # Instance Template
  version {
    instance_template = google_compute_region_instance_template.app-tyko.id
  }

  # Named Port
  named_port {
    name = "webserver"
    port = 80
  }

  # Autohealing Config
  auto_healing_policies {
    health_check      = google_compute_region_health_check.apptokyo.id
    initial_delay_sec = 300
  }
}