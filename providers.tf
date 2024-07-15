provider "google" {}

provider "google" {
  alias                 = "billing-project"
  user_project_override = true
  billing_project       = var.project_id
}

provider "google-beta" {}

provider "google-beta" {
  alias                 = "billing-project"
  user_project_override = true
  billing_project       = var.project_id
}
