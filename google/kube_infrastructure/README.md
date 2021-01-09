# Kubernetes Infrastructure in Google cloud
`data.tf` - <br />
- This manifest define the image that is going to be used in this configuration as a data source.  <br />
`provider.tf` - <br />
&nbsp;&nbsp; `credentials` a json key file for a user that have permissions to do what you want to do with terraform.<br />
&nbsp;&nbsp; `project` - put here the name of the project in google cloud
`master.tf` - <br />
&nbsp;&nbsp; The manifest for the master. 
&nbsp;&nbsp; `google_compute_instance.master.bootdisk.initialize_params.image` - The image from the data source before
&nbsp;&nbsp; `metadata_startup_script` <br />
&nbsp;&nbsp; The script that is going to be run in the initialization of the instance, and install whatever is needed for the master. <br />
`worker_from_tamplate.tf` <br />
&nbsp;&nbsp; `var.default[*]` - The names of the servers that are going to be created <br />
&nbsp;&nbsp; `google_compute_instance_from_template.count` - the number of instances you want to create <br />
&nbsp;&nbsp; `google_compute_instance_from_template.name` - The function needed to apply this resource to each of the variables, by index.
&nbsp;&nbsp; `google_compute_instance_from_template.source_instance_template` - the resource template that is going to be used to create instances
`worker_template.tf` <br />
&nbsp;&nbsp; Settings of regular instances that are going to be used as template


