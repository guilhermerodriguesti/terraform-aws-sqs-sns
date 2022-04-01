resource "aws_dynamodb_table" "int-rede-table" {
  name           = "int-rede-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "FILE_ID"
  range_key      = "FILE_PART_ID"

  attribute {
    name = "FILE_ID"
    type = "S"
  }

  attribute {
    name = "FILE_PART_ID"
    type = "S"
  }

//   attribute {
//     name = "FILE_TYPE"
//     type = "S"
//   }
//   attribute {
//     name = "UPDATED_AT"
//     type = "S"
//   }
  attribute {
    name = "PART_NUMBER"
    type = "N"
  }
//   attribute {
//     name = "FILE_PARTS"
//     type = "N"
//   }
//   attribute {
//     name = "STATUS"
//     type = "S"
//   }
//   attribute {
//     name = "STATUS_DESC"
//     type = "S"
//   }
//   attribute {
//     name = "PAYLOAD"
//     type = "B"
//   }
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "FILE_PART_ID_Index"
    hash_key           = "FILE_PART_ID"
    range_key          = "PART_NUMBER"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["FILE_ID"]
  }

  tags = {
    Name        = "int-rede-table"
    Environment = "production"
  }
}