resource "spacelift_aws_integration" "this" {
  name                          = var.role_name
  role_arn                      = var.role_arn
  generate_credentials_in_worker = false
}
