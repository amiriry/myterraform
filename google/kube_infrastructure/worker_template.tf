resource "google_compute_address" "mystatic" {
   name = "ipv4add1"
   region = "us-central1"
}

resource "google_compute_instance_template" "workertemplate" {
	name = "myworker-template"
	description = "This tamplate is used to create worker for kubernetes cluster"

	machine_type = "e2-small"

	disk {
		source_image = data.google_compute_image.ubuntu_image.self_link
		auto_delete = true
		boot = true
	}

	network_interface {
		network = "default"
		access_config {
			nat_ip = google_compute_address.mystatic.address
		}
	}

	metadata_startup_script = file("bootstrap_kube_sys_worker.sh")
}


