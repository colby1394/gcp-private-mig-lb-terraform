# resource "google_compute_instance" "sample-vm" {
#   name         = "public-iowa-lizzo-loves-me"
#   machine_type = "e2-medium"
#   zone         = "us-central1-a"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.hqinternal.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("./startup-script.sh")

}


resource "google_compute_instance" "sample-vm4" {
  name         = "public-toyko-lizzo-loves-m4"
  machine_type = "e2-medium"
  zone         = "asia-northeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tokyointernal.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = file("./startup.sh")

}
