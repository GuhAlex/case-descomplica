terraform {
  backend "s3" {
    profile                     = ""
    bucket                      = ""
    key                         = "frontend.tfstate"
    region                      = "us-east-1"
    encrypt                     = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
