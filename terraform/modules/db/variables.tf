variable zone {
  description = "Zone"
  default     = "europe-west1-d"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable db_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-base-db"
}

variable db_tags {
  description = "Tags for db"
  default     = ["reddit-db"]
}

variable machine_type {
  description = "Machine type for app"
  default     = "g1-small"
}
