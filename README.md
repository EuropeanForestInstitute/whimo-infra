# Terraform AWS Infra Template

📦 Multi-environment Terraform template for AWS including **EC2**, **S3**, **ECR**, **IAM**, **VPC**, and (optionally) **RDS PostgreSQL**.  
Supports both `prod` and `staging` environments.

---

## 🚀 Features

- VPC with 3 public and 3 private subnets  
- EC2 instances for each environment  
- SSH access via your own public key  
- ECR repositories per environment  
- Isolated S3 buckets per environment  
- IAM roles and instance profiles for EC2 and S3  
- Optional RDS PostgreSQL (enabled only for `prod`)

---

## ✅ Prerequisites

- Terraform `>= 1.0`
- AWS Provider `~> 5.0`
- An S3 bucket for remote state (to be referenced in `backend.tf`)

---

## 🧑‍💻 Setup

### 1) Create `terraform.tfvars`

Create a `terraform.tfvars` file at the repository root with your values (no secrets).

```hcl
project_name = "myproject"
aws_region   = "us-east-1"

environments = {
  prod = {
    instance_type = "t3a.large"
    ami_id        = "ami-xxxxxxxxxxxxxxxxx"
  }
  staging = {
    instance_type = "t3a.large"
    ami_id        = "ami-xxxxxxxxxxxxxxxxx"
  }
}

ssh_allowed_cidrs = ["0.0.0.0/0"]

# RDS (prod only)
create_prod_rds       = true
rds_engine            = "postgres"
rds_engine_version    = "16.3"
rds_instance_class    = "db.t4g.micro"
rds_allocated_storage = 20
rds_db_name           = "app"
rds_username          = "admin"
```

> The RDS password is generated automatically using `random_password` and **should not** be set manually.

### 2) Add your public SSH key

Place your public key in `ssh-keys/your-key.pub` and make sure the Terraform code points to this path.

### 3) Configure your backend (`backend.tf`)

Update `backend.tf` with your S3 state backend **before** running Terraform:

```hcl
terraform {
  backend "s3" {
    bucket  = "your-backend-bucket"
    key     = "myproject/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
```

### 4) Initialize and apply

```bash
terraform init
terraform plan
terraform apply
```

---

## 🗂️ Environments

| Environment | EC2 | S3 | ECR | RDS |
|------------:|:---:|:--:|:---:|:---:|
| `prod`      | ✅  | ✅  | ✅  | ✅  |
| `staging`   | ✅  | ✅  | ✅  | ❌  |

> RDS is enabled by setting `create_prod_rds = true`.

---

## 📁 Repository Layout

```
.
├── backend.tf                 # Configure your S3 backend (edit before init)
├── main.tf                    # Core resources & modules wiring
├── variables.tf               # Input variables
├── terraform.tfvars.example   # (optional) example values
├── versions.tf                # Terraform & providers versions
├── outputs.tf                 # Outputs (sensitive marked accordingly)
├── ssh-keys/
│   └── your-key.pub           # Put your public key here
└── README.md
```

---

**Recommended `.gitignore`:**
```gitignore
.terraform/
*.tfstate
*.tfstate.*
crash.log
*.backup
terraform.tfvars
*.pem
*.key
ssh-keys/*
```


## 🧪 Tested With

- Terraform `>= 1.0`  
- AWS Provider `~> 5.0`

---
