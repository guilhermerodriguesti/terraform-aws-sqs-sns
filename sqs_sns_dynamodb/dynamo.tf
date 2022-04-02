module "dynamodb_table_logs" {
  source         = "terraform-aws-modules/dynamodb-table/aws"
  name           = local.prefix
  hash_key       = "FILE_ID"
  range_key      = "FILE_PART_ID"
  billing_mode   = "PROVISIONED"
  write_capacity = 10
  read_capacity  = 10

  autoscaling_read = {
    scale_in_cooldown = 40
    target_value      = 80
    max_capacity      = 30
  }

  autoscaling_write = {
    scale_in_cooldown = 40
    target_value      = 80
    max_capacity      = 60
  }

  stream_enabled = false
  attributes = [
    {
      name = "FILE_ID"
      type = "S"
    },
    {
      name = "FILE_PART_ID",
      type = "S"
    },
    {
      name = "FILE_TYPE",
      type = "S"
    },
    {
      name = "UPDATE_AT",
      type = "S"
    }
  ]

  global_secondary_indexes = [{
    name               = "FILE_TYPE"
    hash_key           = "UPDATE_AT"
    range_key          = "FILE_TYPE"
    projection_type    = "INCLUDE"
    non_key_attributes = ["PART_NUMBER", "FILE_PARTS", "STATUS", "STATUS_DESC", "PAYLOAD"]
    read_capacity      = 10
    write_capacity     = 10
  }]
}

