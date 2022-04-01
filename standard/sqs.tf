provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  arquivos = [
      "fileA",
      "fileB",
  ]
  prefix = "files"
}

locals {
  topicARNs = [
    for messageName in local.arquivos : "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.prefix}-${messageName}"    
  ]
}

resource "aws_sns_topic" "arquivos" {
  for_each = toset(local.arquivos)
  name     = "${local.prefix}-${each.value}"
}

resource "aws_sqs_queue" "queue" {
  name = "${local.prefix}-queue"
}

resource "aws_sns_topic_subscription" "subscription" {
  for_each  = toset(local.topicARNs) ##toset(values(aws_sns_topic.arquivos)[*].arn)
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue.arn
  topic_arn = each.value
  depends_on = [aws_sns_topic.arquivos]
}


// locals {
//   queue_prefixes = [
//       "queue_Prefix_1",
//       "queue_Prefix_2",
//   ]
// }

// module "sqs" {
//   source = "./../../"

//   for_each = toset(local.queue_prefixes)

//   name        = each.key
//   environment = "dev"
//   label_order = ["name", "environment"]

//   enabled                   = true
//   delay_seconds             = 90
//   max_message_size          = 2048
//   message_retention_seconds = 86400
//   receive_wait_time_seconds = 10
//   policy                    = data.aws_iam_policy_document.document.json
// }

// data "aws_iam_policy_document" "document" {
//   version = "2012-10-17"
//   statement {
//     sid    = "First"
//     effect = "Allow"
//     principals {
//       type        = "AWS"
//       identifiers = ["*"]
//     }
//     actions = ["sqs:SendMessage"]
//     resources = [
//       format("arn:aws:sqs:us-east-1:%s:test-clouddrove-sqs", data.aws_caller_identity.current.account_id)
//     ]
//   }
// }

// resource "aws_sns_topic_subscription" "subscription" {
//   for_each  = toset(local.topicARNs) ##toset(values(aws_sns_topic.arquivos)[*].arn)
//   protocol  = "sqs"
//   endpoint = module.sqs.queue_prefixes
//   #endpoint  = aws_sqs_queue.queue.arn
//   topic_arn = each.value
//   depends_on = [aws_sns_topic.arquivos]
// }