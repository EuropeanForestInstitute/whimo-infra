module "ec2" {
  for_each = var.environments
  source   = "terraform-aws-modules/ec2-instance/aws"
  version  = "~> 5.0"

  name                        = "${var.project_name}-${each.key}-server"
  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.main.key_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.ssh[each.key].id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  iam_instance_profile        = aws_iam_instance_profile.ec2[each.key].name
  create_iam_instance_profile = false


  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2  
    http_protocol_ipv6          = "disabled"
    instance_metadata_tags      = "disabled"
  }

  root_block_device = [{
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }]

  tags = { Environment = each.key }
}
