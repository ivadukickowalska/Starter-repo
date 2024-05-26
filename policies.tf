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

  name = "Trigger stacks that declare an explicit dependency"
  body = file("${path.module}/policies/trigger.rego")
}

# Trigger policies only take effect when attached to the stack.
resource "spacelift_policy_attachment" "trigger" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = spacelift_stack.managed.id
}

# Let's attach the policy to the current stack, so that the child stack is
# triggered, too.
resource "spacelift_policy_attachment" "trigger-self" {
  policy_id = spacelift_policy.trigger.id
  stack_id  = data.spacelift_current_stack.this.id
}
