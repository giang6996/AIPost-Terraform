terraform {
  backend "s3" {
    bucket       = "aipost-terraform-tfstate-108f95d415cf400172f3e"
    key          = "eks/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}