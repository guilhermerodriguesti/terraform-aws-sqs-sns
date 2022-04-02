
resource "aws_sns_topic" "arquivos" {
  for_each = toset(local.arquivos)
  name     = "${local.prefix}-${each.value}"
}
