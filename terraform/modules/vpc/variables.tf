variable ssh_source_ranges {
  description = "Allowed IP Address For SSH connections"
  default     = ["0.0.0.0/0"]
}

variable http_source_ranges {
  description = "Allowed IP Address For HTTP connections"
  default     = ["0.0.0.0/0"]
}
