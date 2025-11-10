resource "aws_key_pair" "main" {
  key_name   = "${local.name}-key"
  public_key = file("${path.module}/ssh-keys/your-key.pub")

  tags = local.tags
}
