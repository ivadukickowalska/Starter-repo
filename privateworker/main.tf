module "workerpool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2"

  configuration = <<-EOT
    export SPACELIFT_TOKEN="${var.worker_pool_config}"
    export SPACELIFT_POOL_PRIVATE_KEY="${var.worker_pool_private_key}"
  EOT

  min_size        = 1
  max_size        = 3
  worker_pool_id  = var.worker_pool_id
  security_groups = var.worker_pool_security_groups
  vpc_subnets     = var.worker_pool_subnets
  ec2_instance_type = "t3.small"
  poweroff_delay = var.poweroff_delay
  spacelift_api_key_endpoint = var.spacelift_api_key_endpoint
  spacelift_api_key_id     = var.spacelift_api_key_id
  spacelift_api_key_secret = var.spacelift_api_key_secret
}
