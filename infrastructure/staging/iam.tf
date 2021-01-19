data "aws_iam_policy_document" "ses_fargate" {
  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ses:SendEmail",
      "ses:SendTemplatedEmail",
      "ses:SendRawEmail",
      "ses:SendBulkTemplatedEmail"
    ]

    condition {
      test = "StringLike"
      variable = "ses:FromAddress"
      values = ["*@${var.mail_from_subdomain}.${var.domain_name}"]
    }
  }
}
