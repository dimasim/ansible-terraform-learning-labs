variable "gcp_project" {
  type        = string
  description = "GCP Project ID Anda"
}

variable "gcp_region" {
  type        = string
  default     = "europe-west1"
  description = "Region untuk deploy VM"
}

variable "gcp_zone" {
  type        = string
  default     = "europe-west1-b"
  description = "Zone untuk deploy VM"
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "User SSH yang akan dibuat di VM"
}

variable "ssh_pub_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Lokasi public key SSH lokal Anda"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}

# 1. VM Instance 1 (web1)
resource "google_compute_instance" "web1" {
  name         = "web1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20220204"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Mengalokasikan IP Publik Ephemeral
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }
}

# 2. VM Instance 2 (web2)
resource "google_compute_instance" "web2" {
  name         = "web2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20220204"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Mengalokasikan IP Publik Ephemeral
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_path)}"
  }
}

# 3. Firewall Rule untuk membuka Port 22 (SSH), 5000 (Flask), dan 8080 (Hazelcast/Calculator)
resource "google_compute_firewall" "allow_web_and_ssh" {
  name    = "allow-web-and-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "5000", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Output IP Publik untuk digunakan di Ansible
output "web1_public_ip" {
  value       = google_compute_instance.web1.network_interface[0].access_config[0].nat_ip
  description = "IP Publik untuk VM web1 (masukkan ke web1 di inventory.ini)"
}

output "web2_public_ip" {
  value       = google_compute_instance.web2.network_interface[0].access_config[0].nat_ip
  description = "IP Publik untuk VM web2 (masukkan ke web2 di inventory.ini)"
}