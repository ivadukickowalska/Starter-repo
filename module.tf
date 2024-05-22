resource "spacelift_module" "k8s-module" {
  name               = "k8s-module"
  terraform_provider = "aws"
  administrative     = true
  branch             = "master"
  description        = "Infra terraform module"
  repository         = "terraform-super-module"
}
