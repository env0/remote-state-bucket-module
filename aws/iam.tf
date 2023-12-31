resource "aws_iam_role" "remote_state_access_role" {
  name = "RoleAssumedByEnv0ForRemoteBackendStateAccess"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          AWS = var.env0_aws_role_name
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "remote-state-access-policy"

    policy = jsonencode({
      Version   = "2012-10-17",
      Statement = [
        # list objects and objects versions in state versions s3 bucket
        {
          Effect = "Allow",
          Action = [
            "s3:ListBucket",
            "s3:ListBucketVersions",
          ],
          Resource = aws_s3_bucket.state_bucket.arn
        },

        # access  objects in state versions s3 bucket
        {
          Effect = "Allow",
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:GetObjectVersion"
          ],
          Resource = "${aws_s3_bucket.state_bucket.arn}/*"
        },
      ]
    })
  }
}
