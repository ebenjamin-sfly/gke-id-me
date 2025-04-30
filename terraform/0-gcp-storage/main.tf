resource "google_storage_bucket" "terraform_state" {
  project                     = "eappanb3"
  name                        = "eb-tf-state-bucket"
  location                    = "US"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  versioning {
    enabled = true
  }
}

