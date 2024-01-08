provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "instance" {
  name         = "gci0"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 25
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    "ssh-keys" = "hallstrom_claes:${file(var.ssh_authorized_keys_path)}"
  }
}

output "instance_ip" {
  value = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}
