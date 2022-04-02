

module "sqs" {
  source = "clouddrove/sqs/aws"

  for_each = toset(local.arquivos)
  name     = "${local.prefix}-${each.value}"

  environment = "dev"
  label_order = ["name", "environment"]

  enabled                   = true
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  policy                    = data.aws_iam_policy_document.document.json
}

data "aws_iam_policy_document" "document" {
  version = "2012-10-17"
  statement {
    sid    = "First"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["sqs:SendMessage"]
    resources = [
      format("arn:aws:sqs:${data.aws_region.current.name}:%s:inte-rede-gb-sqs", data.aws_caller_identity.current.account_id)
    ]
  }
}