resource "aws_ecr_repository" "env" {
  for_each = var.environments
  name     = "${var.project_name}-${each.key}"

  image_tag_mutability = "MUTABLE"
  encryption_configuration { encryption_type = "AES256" }
  image_scanning_configuration { scan_on_push = true }
}

resource "aws_ecr_lifecycle_policy" "env" {
  for_each   = var.environments
  repository = aws_ecr_repository.env[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection    = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 10
        },
        action = { type = "expire" }
      }
    ]
  })
}
