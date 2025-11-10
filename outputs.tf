output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "instance_public_ips" {
  description = "Public IPs per env"
  value       = { for k, m in module.ec2 : k => m.public_ip }
}

output "s3_buckets" {
  value = { for k, b in aws_s3_bucket.env : k => b.bucket }
}

output "ecr_repo_urls" {
  value = { for k, r in aws_ecr_repository.env : k => r.repository_url }
}

output "rds_endpoint" {
  value       = aws_db_instance.prod["prod"].address
  description = "RDS endpoint (hostname)"
}

output "rds_master_username" {
  value       = aws_db_instance.prod["prod"].username
  description = "RDS master username"
}

output "rds_master_password" {
  value       = random_password.rds_master.result
  sensitive   = true
  description = "RDS master password (sensitive)"
}
