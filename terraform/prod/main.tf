provider "google" {
  version = "1.8.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
  app_tags        = ["reddit-app", "prod"]
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
  db_tags         = ["reddit-db", "prod"]
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["90.155.172.250/32"]
}
