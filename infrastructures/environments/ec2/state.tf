
terraform {
  backend "s3" {
    bucket       = "aipost-terraform-tfstate-108f95d415cf400172f3e"
    key          = "ec2/terraform.tfstate" // For EC2 environment tfstate
    region       = "ap-southeast-1"
    profile      = "personal"
    encrypt      = true
    use_lockfile = true
  }
}