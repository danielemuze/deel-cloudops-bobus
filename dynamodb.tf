# DynamoDB Table
resource "aws_dynamodb_table" "reversed_ips" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"  # Fixed billing mode
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  dynamic "replica" {
    for_each = var.replica_regions
    content {
      region_name = replica.value
    }
  }

  tags = {
    Name = var.table_name
  }
}
