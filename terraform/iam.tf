# DATA
data "aws_iam_policy_document" "webserver-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "webserver_permissions" {
  statement {
    effect = "Allow"

    actions = [
        "autoscaling:*",
        "elasticloadbalancing:*"
    ]

    resources = [
      "*",
    ]
  }
}

# POLICY
resource "aws_iam_policy" "webserver_permissions" {
  name = "webserver_permissions"
  policy      = data.aws_iam_policy_document.webserver_permissions.json
}

# POLICY ATTACHMENT
resource "aws_iam_policy_attachment" "webserver_permissions" {
  name       = "webserver_permissions"
  policy_arn = aws_iam_policy.webserver_permissions.arn

  roles = [
    aws_iam_role.webserver_role.id
  ]
}

# ROLE
resource "aws_iam_role" "webserver_role" {
  name = "webserver_role"
  assume_role_policy = data.aws_iam_policy_document.webserver-assume-role-policy.json
}

resource "aws_iam_instance_profile" "webserver" {
  name_prefix = "webserver"
  role        = aws_iam_role.webserver_role.name
}
