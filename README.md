# 🚀 Infrastructure Setup Using AWS CLI, Terraform & Jenkins

This project guides you through setting up a complete DevOps-ready infrastructure using **AWS CLI**, **Terraform**, and **Jenkins** on an EC2 instance. It includes step-by-step instructions for installing tools, configuring IAM, setting up Jenkins, managing Terraform remote state with S3, and more.

---

## 📌 Table of Contents

- [Prerequisites](#prerequisites)
- [Tool Installation](#tool-installation)
  - [Install AWS CLI](#install-aws-cli)
  - [Install Terraform](#install-terraform)
  - [Install Jenkins on EC2](#install-jenkins-on-ec2)
- [IAM User Setup](#iam-user-setup)
- [Configure AWS CLI](#configure-aws-cli)
- [Create S3 Bucket for Terraform State](#create-s3-bucket-for-terraform-state)
- [Project Setup & Usage](#project-setup--usage)
- [Folder Structure](#folder-structure)
- [License](#license)

---

## ✅ Prerequisites

- AWS Account
- SSH key pair for EC2 access
- Basic knowledge of AWS, Terraform, and Linux CLI

---

## 🔧 Tool Installation

### 📥 Install AWS CLI

#### On EC2 (Amazon Linux 2):
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version ```bash



### 📦 Install Terraform on EC2
bash
Copy
Edit
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -version
