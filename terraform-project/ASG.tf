#this block of codeadds an autoscaling group in a zone specified in the variables file using an instance group manager as a target

resource "google_compute_autoscaler" "demo" {
     depends_on = [
        google_sql_database_instance.database,
        
    ]
  name   = var.ASG_name
  zone   = var.zone
  target = google_compute_instance_group_manager.my-igm.self_link

  # section where you can define the number of instances running by editing the variables file under maximum or minimum

  autoscaling_policy {
    max_replicas    = var.maximum_instances
    min_replicas    = var.minimum_instances
    cooldown_period = 60
  }
}

#creating a target pool

resource "google_compute_target_pool" "team3" {
  name    = var.targetpool_name
  project = var.project_name
  region  = var.region
}

#creating a group manager for the instances.
resource "google_compute_instance_group_manager" "my-igm" {
  name    = var.igm_name
  zone    = var.zone
  project = var.project_name
  version {
    instance_template = google_compute_instance_template.compute-engine.self_link
    name              = "primary"
  }
  target_pools       = [google_compute_target_pool.team3.self_link]
  base_instance_name = "team3"
}

#indicating the image for the instance.

data "google_compute_image" "centos_7" {
  family  = "centos-7"
  project = "centos-cloud"
}