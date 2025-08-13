provider "google" {
  add_terraform_attribution_label               = true
  terraform_attribution_label_addition_strategy = "CREATION_ONLY"
}

data "google_service_accounts" "example" {
}

output "test" {
  value = google_service_accounts.example[0].email
}