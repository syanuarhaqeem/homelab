variable "cloudflare_account_id" {
  description = "Cloudflare account ID (R2 endpoint)."
  type        = string
}

variable "state_passphrase" {
  description = "Passphrase for state and plan encryption (16+ characters)."
  type        = string
  sensitive   = true
}
