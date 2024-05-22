resource "spacelift_stack" "infra" {
  branch     = "master"
  name       = "Infrastructure stack"
  repository = "tftest"
}

resource "spacelift_stack" "app" {
  branch     = "master"
  name       = "Application stack"
  repository = "tftest"
}

resource "spacelift_stack_dependency" "test" {
  stack_id            = spacelift_stack.app.id
  depends_on_stack_id = spacelift_stack.infra.id
}

resource "spacelift_stack_dependency_reference" "test" {
  stack_dependency_id = spacelift_stack_dependency.test.id
  output_name         = "DB_CONNECTION_STRING"
  input_name          = "APP_DB_URL"
}
