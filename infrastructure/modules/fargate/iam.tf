data "aws_iam_policy_document" "ssm_read" {
  statement {
    effect    = "Allow"

    actions   = [ "ssm:GetParametersByPath" ]

    resources = ["arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.env}/*"]
  }
}