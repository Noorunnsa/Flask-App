# Setting Up Infrastructure with Terraform

## Infrastructure Overview

This includes the complete infrastructure setup for deploying the Flask application on AWS, utilizing various cloud components:

**VPC**: A dedicated Virtual Private Cloud (VPC) to ensure network isolation.

**Subnets**: 2 Public and 2 Private subnets distributed across multiple availability zones for high availability.

**Route Tables**: Configured to manage traffic flow between different network components.

**Internet Gateway**: Provides internet access for resources within public subnets.

**NAT Gateway**: Enables outbound internet access for private subnets while maintaining security.

**Elastic Container Service (ECS)**: Orchestrates the deployment of the Flask application using containers. The ECS service is deployed in two private subnets.

**Application Load Balancer (ALB)**:  Distributes incoming traffic across ECS task for better performance and reliability.

**Security Groups**: Firewall rules to control inbound and outbound traffic, ensuring secure access.

## Prerequisites
To run this project, you need:
- Terraform installed on your system
- Git for cloning the repository
- An EC2 instance (ubuntu 22.04 lts, t2.micro, 8 GB)

## Getting Started

1. Clone the repository and navigate to the `terraform` directory inside it.

```bash
 cd /home/ubuntu
 git clone https://github.com/Noorunnsa/Flask-App.git
 cd Flask-App/terraform
```

2. Create an IAM user on AWS and download the `.csv` file containing the access keys.

3. Configure AWS credentials:

Create a file at `/home/ubuntu/Flask-App/terraform/.aws/credentials` and add the following content:

```ini
[default]
aws_access_key_id=<enter_access_key_here>
aws_secret_access_key=<enter_secret_access_key_here>
```
 Export the credentials file:

```bash
export AWS_SHARED_CREDENTIALS_FILE=/home/ubuntu/Flask-App/terraform/.aws/credentials
```

> **Note:** Ensure that the `.aws` directory is in the same location where the Terraform files are stored.

## IAM Policy Configuration

Follow the **least privilege principle** and attach only the necessary policies to the IAM user for Terraform execution.

Attach the following policies to the IAM user:
- `AmazonVPCFullAccess`
- `IAMFullAccess`
- `AmazonEC2FullAccess`
- `AmazonECS_FullAccess`
- `CloudWatchFullAccess`
- `AmazonS3FullAccess`
- `AmazonDynamoDBFullAccess`


Create a custom inline policy named `custom-app-autoscaling` with the following JSON and attach it to the IAM user:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "application-autoscaling:ListTagsForResource",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingPolicies"
            ],
            "Resource": "*"
        }
    ]
}
```

## Installing Terraform

Execute the installation script:

```bash
chmod +x install-terraform.sh
sh ./install-terraform.sh
```

## Deploying the Infrastructure

1. Initialize Terraform and validate the configuration:

```bash
terraform init
terraform validate
terraform plan --var-file=terraform.tfvars
```

2. Apply the configuration to provision the resources:

```bash
terraform apply --var-file=terraform.tfvars
```

## Verifying Deployment

Once the deployment is complete, retrieve the **DNS name of the Application Load Balancer (ALB)** from the AWS Console and enter it in your browser.

You should see a webpage displaying the **timestamp** along with the **IP address of the requester**.

---
