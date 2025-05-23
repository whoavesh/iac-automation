# 🚀 Project Setup Full Guide
This project guides you through setting up a complete DevOps-ready automated infrastructure provisioning pipeline using **AWS CLI**, **Terraform**, and **Jenkins** on an EC2 instance. It includes step-by-step instructions for installing tools, configuring IAM, setting up Jenkins, managing Terraform remote state with S3, and more.

Fork this repository in you github account and follow the below guide to setup this project.

## ✅ Prerequisites

- AWS Account
- EC2 server
- SSH key pair for EC2 access
- Basic knowledge of AWS, Terraform, and Linux CLI

---
# Enviroment Setup
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
- Download the `.pem` or `.ppk` file and store it securely — needed for SSH access

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

Execute the below command using any remote client tool like putty or mobaXterm (Change the key file type according to your preference).
```bash
ssh -i "your-key.pem" ubuntu@<your-ec2-public-ip>
```

## 🔧 Tool Installation
### 📥 Install AWS CLI On EC2 (Amazon Linux 2):
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version 
```
---

### 🧰 Install Jenkins on EC2
Launch an EC2 instance (Amazon Linux 2)

SSH into the instance:

```bash
ssh -i "your-key.pem" ec2-user@<your-ec2-public-ip>
```
Install Java:

```bash
sudo yum install java-11-amazon-corretto -y
```
Add Jenkins repo and install:

```bash
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
```
Open port 8080 in EC2 security group.

Access Jenkins:
```
http://<your-ec2-public-ip>:8080
```
---

### 🔐 IAM User Setup
Go to AWS Console → IAM → Users → Add User

Name your user (e.g., terraform-user)

Enable Programmatic access

Attach the following policies:

- AmazonS3FullAccess

- AdministratorAccess
---

### 🧩 Configure AWS CLI
Run the following on EC2 or local machine:

```bash
aws configure
```
Then provide:

- Access Key ID of IAM User 

- Secret Access Key of IAM User

- Default region (e.g., us-east-1) (leave it default, press enter)

- Output format (e.g., json)  (leave it default, press enter)

---

### 🪣 Create S3 Bucket for Terraform Remote State
```bash
aws s3api create-bucket \
  --bucket your-terraform-state-bucket \
  --region us-east-1 \
  --create-bucket-configuration LocationConstraint=us-east-1
```
Replace your-terraform-state-bucket with a unique bucket name.

---


# Project Setup
## ⚙️ Automated Provisioning Pipeline setup

Follow these steps to create a automated infrastructure provisioning pipeline.

---

### ✅ Step 1: Install Terraform on Jenkins Server

SSH into your Jenkins EC2 instance and run the following:

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -version
```
---
### ✅ Step 2: Create a Declarative Pipeline Project in Jenkins
Go to Jenkins Dashboard → New Item

Enter a project name (e.g., Terraform-Pipeline)

Select Pipeline, then click OK

## ⚙️ 2.1 Configure the Pipeline from GitHub SCM
In the pipeline configuration page:

Scroll to Pipeline

Under Definition, choose Pipeline script from SCM

SCM: Select Git

Repository URL: Paste your GitHub repository link containing Jenkinsfile

Set credentials if it's a private repo

## 🔁 2.2 Enable GitHub Webhooks
Under the Build Triggers section:

Check GitHub hook trigger for GITScm polling

Go to your GitHub repository → Settings → Webhooks

Add a new webhook:

- Payload URL: http://<your-jenkins-server>:8080/github-webhook/

- Content type: application/json

- Select: send me everything

Save

---
### ✅ Step 3: Generate Google App Password
Go to your Google Account Security Settings

Under "Signing in to Google", select App Passwords

Authenticate and choose:

- App: Mail

- Device: Other (e.g., Jenkins)
Generate and copy the 16-character app password

---
### ✅ Step 4: Configure Gmail for Extended Email Notifications
Go to Manage Jenkins → Configure System

Scroll to Extended E-mail Notification

Use the following:

- SMTP server: smtp.gmail.com

- SMTP port: 465 (SSL)

Use SMTP Authentication: ✅

- Username: your Gmail address (e.g., you@gmail.com)

- Password: App password (Paste the 16-character app password in the password field)

SMTP TLS/SSL: ✅ enabled

Test the configuration using the "Test configuration by sending test e-mail" option

---


## 🚀 Executing the Automated Infrastructure Provisioning Pipeline

To trigger the pipeline:

1. **Make any changes to the `infra.tf` file** in your GitHub repository (e.g., update a resource, add a tag, modify an instance type).
2. **Push the changes** to the main branch.

As soon as the changes are pushed:

- Jenkins will **automatically trigger the pipeline** using the configured GitHub webhook.
- You can monitor the pipeline execution from the **Jenkins dashboard**.
- Once completed, the **infrastructure will be automatically provisioned** (or updated) on AWS based on the new configuration in `infra.tf`.
- Copy the dns of Loadbalancer, a sample website will be deployed on ec2.

✅ This ensures **fully automated, version-controlled infrastructure management** using Terraform and Jenkins CI/CD.

