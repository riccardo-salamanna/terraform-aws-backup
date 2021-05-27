data "aws_iam_policy_document" "backup_events" {
  count = var.enabled && length(var.notifications) > 0 ? 1 : 0
  statement {
    actions = [
      "SNS:Publish",
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
    resources = [
      lookup(var.notifications, "sns_topic_arn", null)
    ]
    sid = "BackupPublishEvents"
  }
}

resource "aws_sns_topic_policy" "backup_events" {
  count  = var.enabled && length(var.notifications) > 0 ? 1 : 0
  arn    = lookup(var.notifications, "sns_topic_arn", null)
  policy = data.aws_iam_policy_document.backup_events[0].json
}
