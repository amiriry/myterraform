resource "google_compute_address" "static-master" {
   name = "ipv4addmaster"
   region = "us-central1"
}

resource "google_compute_instance" "master" {
	name = "master"
	machine_type = "e2-small"
	zone = "us-central1-a"
	boot_disk {
		initialize_params {
			image = data.google_compute_image.ubuntu_image.self_link 
		}
	}

	network_interface {
		network = "default"
		access_config {
			nat_ip = google_compute_address.static-master.address
		}
	}

	metadata = {
		Name = "kubernetes-master"
	}

	metadata_startup_script = file("bootstrap_kube_sys_server.sh")

}
