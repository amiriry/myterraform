# Google Cloud  manifests

#### kube_infrstructure - 
Terraform will create instances as the amount you give in `worker_from_template.tf` in `count` variable. You have to put in variable `instance_names` names as the number of count variable.

#### multiple_instances - 
Create the amount of nodes you specify in `google_compute_instance_from_template.workers.count`.<br/ > 
In addition under `var.instance_names` inside `default` add the indexes and names as the amount of instances you want

#### one-instance -
Create one instance in default network and with tag foo="bar" <br />
The inbstance is debian-9
