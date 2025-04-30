# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"
    disk_size_gb = 20

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    # EB added resource_labels & kubelet_config
    resource_labels = {
      "goog-gke-node-pool-provisioning-model" = "on-demand"
    }
    kubelet_config {
      cpu_manager_policy = ""
      cpu_cfs_quota      = false
      pod_pids_limit     = 0
    }
  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    spot = true
    #    preemptible  = true
    #    machine_type = "e2-small"
    #    machine_type = "e2-medium"
    #    machine_type = "e2-standard-2"
    #    machine_type = "e2-standard-4"
    machine_type = "c3-standard-4-lssd"
    # Following is required for local SSD disk VMs
    ephemeral_storage_local_ssd_config {
      local_ssd_count = 1
    }

    labels = {
      team = "devops"
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "PREFER_NO_SCHEDULE"
      #      effect = "NO_SCHEDULE"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    # EB added resource_labels & kubelet_config
    resource_labels = {
      "goog-gke-node-pool-provisioning-model" = "spot"
    }
    kubelet_config {
      cpu_manager_policy = ""
      cpu_cfs_quota      = false
      pod_pids_limit     = 0
    }
  }
}
