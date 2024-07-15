output "name" {
  description = "The name of the nvs vm"
  value       = google_compute_instance.nva.name
}

output "zone" {
  description = "The zone of the nva vm"
  value       = google_compute_instance.nva.zone
}

output "region" {
  description = "The region of the nva vm"
  value       = provider::google::region_from_zone(google_compute_instance.nva.zone)
}

output "self_link" {
  description = "The uri of the nva vm"
  value       = google_compute_instance.nva.self_link
}

output "ip_address" {
  description = "The description of the nvs vm"
  value       = google_compute_address.address_peer.address
}

output "interface" {
  description = "The name of the cloud router interface created for the nva vm"
  value       = google_compute_router_interface.interface.name
}

output "redundant_interface" {
  description = "The name of the redundant cloud router interface created for the nva vm"
  value       = google_compute_router_interface.interface_redundant.name
}
