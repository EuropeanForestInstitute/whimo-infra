############################
# EC2 trust policy (assume)
############################
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    sid     = "Ec2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

############################
# Role per environment
############################
resource "aws_iam_role" "ec2" {
  for_each           = var.environments
  name               = "${var.project_name}-${each.key}-ec2-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
  description        = "EC2 role for ${each.key} to access its own S3 bucket"
}

############################################
# S3 access policy (only to its own bucket)
############################################
data "aws_iam_policy_document" "s3_access" {
  for_each = var.environments

  statement {
    sid     = "ListOwnBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      aws_s3_bucket.env[each.key].arn
    ]
  }

  statement {
    sid     = "RWObjectsInOwnBucket"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "${aws_s3_bucket.env[each.key].arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "s3_access" {
  for_each = var.environments
  name     = "${var.project_name}-${each.key}-s3-access"
  role     = aws_iam_role.ec2[each.key].id
  policy   = data.aws_iam_policy_document.s3_access[each.key].json
}

############################################
# Instance profile per environment
############################################
resource "aws_iam_instance_profile" "ec2" {
  for_each = var.environments
  name     = "${var.project_name}-${each.key}-ec2-profile"
  path     = "/"
  role     = aws_iam_role.ec2[each.key].name
}
