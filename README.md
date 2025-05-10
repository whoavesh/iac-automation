# 🚀 Infrastructure Setup Using AWS CLI, Terraform & Jenkins

This project guides you through setting up a complete DevOps-ready infrastructure using **AWS CLI**, **Terraform**, and **Jenkins** on an EC2 instance. It includes step-by-step instructions for installing tools, configuring IAM, setting up Jenkins, managing Terraform remote state with S3, and more.

## ✅ Prerequisites

- AWS Account
- SSH key pair for EC2 access
- Basic knowledge of AWS, Terraform, and Linux CLI

---

## 🖥️ EC2 Instance Creation (Ubuntu with t2.medium)

Follow these steps to create an EC2 instance that will host Jenkins and other tools.

### 🔹 Step 1: Login to AWS Management Console

- Navigate to [EC2 Dashboard](https://console.aws.amazon.com/ec2/).
- Change you region to (eu-west-2) by clicking dropdown on top right corner.

---

### 🔹 Step 2: Launch Instance

1. Click on **Launch Instance**
2. Set the name: `jenkins-server` (or any preferred name)

---

### 🔹 Step 3: Choose AMI (Amazon Machine Image)

- Choose **Ubuntu Server 22.04 LTS (HVM), SSD Volume Type**
- Architecture: **x86_64**
- Virtualization type: **HVM**

---

### 🔹 Step 4: Choose Instance Type

- Select instance type: **`t2.medium`**
  - 2 vCPU, 4 GiB RAM — suitable for Jenkins and other DevOps tools

---

### 🔹 Step 5: Create/Select Key Pair

- Create a new key pair or select an existing one
- Download the `.pem` file and store it securely — needed for SSH access

---

### 🔹 Step 6: Configure Network Settings

- Select **Allow HTTP traffic from the internet**
- Select **Allow HTTPS traffic from the internet**
- (Optional) Open **port 8080** for Jenkins access

---

### 🔹 Step 7: Configure Storage

- Set **Root Volume Size** to **10 GiB** (default is often 8 GiB)
- Volume Type: **General Purpose SSD (gp2 or gp3)**

---

### 🔹 Step 8: Launch the Instance

- Review all settings and click **Launch Instance**

---

### 🔹 Step 9: Connect to Your Instance

After the instance is in "Running" state:

```bash
ssh -i "your-key.pem" ubuntu@<your-ec2-public-ip>
```

## 🔧 Tool Installation

### 📥 Install AWS CLI

#### On EC2 (Amazon Linux 2):
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version 
```

#### 📦 Install Terraform on EC2
```bash
Copy
Edit
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -version
```



#### 🧰 Install Jenkins on EC2
Launch an EC2 instance (Amazon Linux 2)

SSH into the instance:

```bash
Copy
Edit
ssh -i "your-key.pem" ec2-user@<your-ec2-public-ip>
```
Install Java:

```bash
Copy
Edit
sudo yum install java-11-amazon-corretto -y
```
Add Jenkins repo and install:

```bash
Copy
Edit
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
Open port 8080 in EC2 security group.

Access Jenkins:
```
Copy
Edit
http://<your-ec2-public-ip>:8080
```

#### 🔐 IAM User Setup
Go to AWS Console → IAM → Users → Add User

Name your user (e.g., terraform-user)

Enable Programmatic access

Attach the following policies:

AmazonS3FullAccess

AdministratorAccess

Complete creation and download the .csv file with access keys


#### 🧩 Configure AWS CLI
Run the following on EC2 or local machine:

```bash
Copy
Edit
aws configure
```
Then provide:

Access Key ID of IAM User 

Secret Access Key of IAM User

Default region (e.g., us-east-1) (leave it default, press enter)

Output format (e.g., json)  (leave it default, press enter)


#### 🪣 Create S3 Bucket for Terraform Remote State
```bash
Copy
Edit
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1 \
  --create-bucket-configuration LocationConstraint=us-east-1
```
Replace your-terraform-state-bucket with a unique bucket name.
