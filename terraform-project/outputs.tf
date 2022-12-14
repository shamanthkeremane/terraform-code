output "name_of_vpc" {
  value = google_compute_network.vpc-network-demo.name

}

output "db_instance_Information" {
  value = google_sql_database_instance.database
  sensitive = true
}