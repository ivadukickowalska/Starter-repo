resource "spacelift_aws_integration" "this" {
  name                          = var.role_name
  role_arn                      = var.role_arn
  space_id = spacelift_space.starter-repo.id
  generate_credentials_in_worker = false
}
