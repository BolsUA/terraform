variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment (dev/staging/prod)"
}

variable "delay_seconds" {
  type        = number
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  default     = 0
}

variable "max_message_size" {
  type        = number
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  default     = 262144  # 256 KB
}

variable "retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message"
  default     = 345600  # 4 days
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "The time for which a ReceiveMessage call will wait for a message to arrive"
  default     = 0
}

variable "visibility_timeout" {
  type        = number
  description = "The visibility timeout for the queue in seconds"
  default     = 30
}

variable "enable_dlq" {
  type        = bool
  description = "Enable Dead Letter Queue"
  default     = true
}

variable "max_receive_count" {
  type        = number
  description = "Maximum number of times a message can be received before being sent to the DLQ"
  default     = 3
}

variable "dlq_retention_seconds" {
  type        = number
  description = "The number of seconds Amazon SQS retains a message in the DLQ"
  default     = 1209600  # 14 days
}