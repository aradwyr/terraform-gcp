provider "google" {
  credentials = file("<FILE_PATH>.json")

  project = "<GCP_PROJECT_ID>"
  region  = "us-west1"
  zone    = "us-west1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network001"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network       = "default"
    access_config {
    }
  }
}
