terraform {
  required_version = ">= 0.12"
}


provider "aws" {
  region = "us-east-1"
  version = "~> 2.25"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  topics = [
      "topicA",
      "topicB",
  ]
  prefix = "topic"
}
locals {
  topicARNs = [
    for messageName in local.topics : "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.prefix}-${messageName}"    
  ]
}

resource "aws_sns_topic" "topics" {
  for_each = toset(local.topics)
  name     = "${local.prefix}-${each.value}"
}

resource "aws_sqs_queue" "queue" {
  name = "${local.prefix}-queue"
}


resource "aws_sns_topic_subscription" "subscription" {
  for_each  = toset(local.topicARNs) ##toset(values(aws_sns_topic.topics)[*].arn)
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue.arn
  topic_arn = each.value
  depends_on = [aws_sns_topic.topics]
}


