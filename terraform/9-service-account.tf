# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "service-a" {
  account_id = "service-a"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "service-a" {
  for_each = toset([
    "roles/storage.admin",
    "roles/artifactregistry.admin",
    "roles/artifactregistry.repoAdmin",
    "roles/servicedirectory.editor",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/secretmanager.secretAccessor",
    "roles/iam.serviceAccountTokenCreator",
  ])
  project = "iconic-star-416704"
  #  project = "devops-v4"
  role = each.key
  #  role    = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service-a.email}"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.service-a.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:iconic-star-416704.svc.id.goog[staging/service-a]"
  #  member             = "serviceAccount:devops-v4.svc.id.goog[staging/service-a]"
}

# Binding the default namespace
resource "google_service_account_iam_member" "service-a-default" {
  service_account_id = google_service_account.service-a.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:iconic-star-416704.svc.id.goog[default/service-a]"
  #  member             = "serviceAccount:iconic-star-416704.svc.id.goog[staging/service-a]"
  #  member             = "serviceAccount:devops-v4.svc.id.goog[staging/service-a]"
}