terraform {
  backend "s3" {
    bucket       = "phoenix-tf-state-uremnwaogu3-4050"
    key          = "phoenix/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
    encrypt      = true
  }
}