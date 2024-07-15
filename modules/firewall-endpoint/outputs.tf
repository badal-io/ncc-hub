output "security_profile_group_id" {
  description = "An identifier for the security profile group with the format `{{parent}}/locations/{{location}}/securityProfileGroups/{{name}}`"
  value       = google_network_security_security_profile_group.default.id
}
