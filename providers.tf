terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.79.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.80.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.11.0"
    }
  }
  required_version = ">= 1.5.3"
}

provider "google" {
  project = var.google_project_id
}

provider "google-beta" {
  project = var.google_project_id
}

provider "mongodbatlas" {}
