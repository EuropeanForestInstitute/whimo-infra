variable "project_name" {
  description = "Project name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environments" {
  description = "Map of envs to EC2 settings"
  type = map(object({
    instance_type = string
    ami_id        = string
  }))
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH (port 22)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# RDS (prod only)
variable "create_prod_rds" {
  type    = bool
  default = true
}

variable "rds_engine" {
  type    = string
  default = "postgres"
}

variable "rds_engine_version" {
  type    = string
  default = "16.3"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_db_name" {
  type    = string
  default = "app"
}

variable "rds_username" {
  type    = string
  default = "app"
}
