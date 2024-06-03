# PLAN POLICY
#
# This example plan policy prevents you from creating weak passwords, and warns 
# you when passwords are meh.
#
# You can read more about plan policies here:
#
# https://docs.spacelift.io/concepts/policy/terraform-plan-policy
resource "spacelift_policy" "plan" {
  type = "PLAN"
  space_id = spacelift_space.starter-repo.id
  name = "Enforce password strength"
  body = file("${path.module}/policies/plan.rego")
}

# Plan policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "plan" {
  policy_id = spacelift_policy.plan.id
  stack_id  = spacelift_stack.managed.id
}

# PUSH POLICY
#
# This example Git push policy ignores all changes that are outside a project's
# root. Other than that, it follows the defaults - pushes to the tracked branch
# trigger tracked runs, pushes to all other branches trigger proposed runs, tag
# pushes are ignored.
#
# You can read more about push policies here:
#
# https://docs.spacelift.io/concepts/policy/git-push-policy
resource "spacelift_policy" "push" {
  type = "GIT_PUSH"
  space_id = spacelift_space.starter-repo.id
  name = "Ignore commits outside the project root"
  body = file("${path.module}/policies/push.rego")
}

# Push policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "push" {
  policy_id = spacelift_policy.push.id
  stack_id  = spacelift_stack.managed.id
}

# TRIGGER POLICY
#
# This example trigger policy will cause every stack that declares dependency on
# the current one to get triggered the current one is successfully updated.
#
# You can read more about trigger policies here:
#
# https://docs.spacelift.io/concepts/policy/trigger-policy
resource "spacelift_policy" "trigger" {
  type = "TRIGGER"
  space_id = spacelift_space.starter-repo.id
  name = "Trigger stacks that declare a dependency explicitly"
  body = file("${path.module}/policies/trigger.rego")
}

# Trigger policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "trigger" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = spacelift_stack.managed.id
}

# This resource defines a Spacelift context - a package of reusable
# configuration.
#
# You can read about contexts here:
#
# https://docs.spacelift.io/concepts/context
resource "spacelift_context" "managed" {
  name        = "Managed context"
  description = "Your first context managed by Terraform"
  space_id = spacelift_space.starter-repo.id
}

# This is an envioronment variable defined on the context level. When the
# context is attached to the stack, this variable will be added to the stack's
# own environment. And that's how we do configuration reuse here at Spacelift.
# This evironment variable has its write_only bit explicitly set to false, which
# means that you'll be able to read back its valie from both the GUI and the API.
#
# You can read more about environment variables here:
#
# https://docs.spacelift.io/concepts/environment#environment-variables

resource "spacelift_environment_variable" "context-plaintext" {
  context_id = spacelift_context.managed.id
  name       = "CONTEXT_PUBLIC"
  value      = "This should be visible!"
  write_only = false
}

# For another (secret) variable, let's create programmatically create a super
# secret password.
resource "random_password" "context-password" {
  length  = 32
  special = true
}

# This is a secret environment variable. Note how we didn't set the write_only
# bit at all here. This setting always defaults to "true" to protect you against
# an accidental leak of secrets. There will be no way to retrieve the value of
# this variable programmatically, but it will be available to your Spacelift
# runs.
#
# If you accidentally print it out to the logs, no worries: we will obfuscate
# every secret thing we know of.
resource "spacelift_environment_variable" "context-writeonly" {
  context_id = spacelift_context.managed.id
  name       = "CONTEXT_SECRET"
  value      = random_password.context-password.result
}

# Apart from setting environment variables in your Contexts, you can add files
# to be mounted directly in Spacelift's workspace. For the purpose of this
# experiment, let's export our environemnt variables as JSON-encoded files, too.
# 
# You can read more about mounted files here: 
#
# https://docs.spacelift.io/concepts/environment#mounted-files
resource "spacelift_mounted_file" "context-plaintext-file" {
  context_id    = spacelift_context.managed.id
  relative_path = "context-plaintext-file.json"
  content = base64encode(jsonencode({
    payload = spacelift_environment_variable.context-plaintext.value
  }))
  write_only = false
}

# Since you can't read back the value from a write-only environment variable
# like we just did that for the read-write one, we'll need to retrieve the value
# of the password directly from its resource.
resource "spacelift_mounted_file" "context-secret-file" {
  context_id    = spacelift_context.managed.id
  relative_path = "context-secret-password.json"
  content       = base64encode(jsonencode({ password = random_password.context-password.result }))
}

# This resource attaches context to a Stack. Since this is many-to-many
# relationship and a single Stack can have multiple contexts attached to it, the
# priority value can be set to indicate the precedence this context should take
# in case of clashes/overrides. The lower the number, the higher the priority.
#
# You can read about attaching and detaching contexts here:
#
# https://docs.spacelift.io/concepts/context#attaching-and-detaching
resource "spacelift_context_attachment" "managed" {
  context_id = spacelift_context.managed.id
  stack_id   = spacelift_stack.managed.id
  priority   = 0
}
