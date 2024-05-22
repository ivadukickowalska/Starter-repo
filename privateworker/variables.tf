variable "worker_pool_config" {
  description = "Configuration for the worker pool"
  type        = string
}

variable "worker_pool_private_key" {
  description = "Private key for the worker pool"
  type        = string
}

variable "worker_pool_id" {
  description = "ID of the worker pool"
  type        = string
}

variable "spacelift_api_key_id" {
  type        = string
  description = "ID of the Spacelift API key to use"
}

variable "spacelift_api_key_secret" {
  type        = string
  sensitive   = true
  description = "Secret corresponding to the Spacelift API key to use"
}

variable "spacelift_api_key_endpoint" {
  type        = string
  description = "Full URL of the Spacelift API endpoint to use, eg. https://demo.app.spacelift.io"
}

variable "worker_pool_security_groups" {
  description = "The security groups to be used for the worker pool"
  type        = list(string)
}

variable "worker_pool_subnets" {
 description = "The subnets to be used for the worker pool"
  type        = list(string)
}

 variable "poweroff_delay" {
   type = number
   description = "number of seconds to wait before shutting down a failed instance"
 }

 variable "autoscaling_max_create" {
  description = "The maximum number of instances the utility is allowed to create in a single run"
  type        = number
  default     = 2
}

variable "autoscaling_max_terminate" {
  description = "The maximum number of instances the utility is allowed to terminate in a single run"
  type        = number
  default     = 1
}
