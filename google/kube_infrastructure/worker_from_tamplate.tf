variable "instance_names" {
	default = {
		"0" = "worker1"
		"1" = "worker2"
		"2" = "worker3"
	}
}
resource "google_compute_instance_from_template" "workers" {
	count = 3
	name = lookup(var.instance_names, count.index)
	zone = "us-central1-a"

	source_instance_template = google_compute_instance_template.workertemplate.id
}

