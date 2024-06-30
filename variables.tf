variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1"
}

variable "replica_regions" {
  description = "The regions to create replicas in"
  type        = list(string)
  default     = ["us-west-1", "eu-west-1"]
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  default     = "reversed_ips"
}
