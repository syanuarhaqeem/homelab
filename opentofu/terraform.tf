terraform {
  required_version = ">= 1.12"

  backend "s3" {
    bucket       = "homelab-tofu-state"
    key          = "homelab.tfstate"
    region       = "auto"
    use_lockfile = true

    endpoints = {
      s3 = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
    }

    # for non-AWS S3
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }

  encryption {
    key_provider "pbkdf2" "state" {
      passphrase = var.state_passphrase
    }

    method "aes_gcm" "state" {
      keys = key_provider.pbkdf2.state
    }

    state {
      method   = method.aes_gcm.state
      enforced = true
    }

    plan {
      method   = method.aes_gcm.state
      enforced = true
    }
  }
}
