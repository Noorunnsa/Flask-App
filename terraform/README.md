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

## Dynamic Subnet Creation Process Based on Given VPC CIDR

## Private Subnets:

- Each subnet will be allocated a specific portion of the larger 10.0.0.0/16 CIDR block, using the cidrsubnet function with a subnet prefix length of 8.
- This function divides the main CIDR block into smaller subnets, each with a /24 CIDR block.
- The number of subnets to be created will depend on how many entries are defined in the var.private_subnets variable (each entry corresponds to one subnet).
- For example, var.private_subnets has 2 entries, the resulting subnets could be:

Private Subnet 1: 10.0.0.0/24
Private Subnet 2: 10.0.1.0/24

## Public Subnets:

- The logic for the public subnets is similar to the private subnets, but with a shift in the starting point for the CIDR block by adding 100 to the value of each.value.
- This helps to avoid overlapping with the private subnets.
- Each public subnet is also a /24 subnet, created by shifting the subnet number with the addition of 100.
- For example, var.public_subnets has 2 entries, the resulting public subnets could be:

Public Subnet 1: 10.0.100.0/24
Public Subnet 2: 10.0.101.0/24

## Availability Zones:
- Each subnet is assigned to an availability zone using tolist(data.aws_availability_zones.available.names)[each.value].
- The availability zone index is determined by the each.value variable from the var.private_subnets and var.public_subnets maps.
- each.value corresponds to an index from the var.private_subnets or var.public_subnets variable.
- The data.aws_availability_zones.available.names fetches the available availability zones in the region.

Example: 

If data.aws_availability_zones.available.names = ["us-east-1a", "us-east-1b", "us-east-1c"], the availability zones will be assigned as follows:

- Private Subnet 1: us-east-1a
- Private Subnet 2: us-east-1b
- Public Subnet 1: us-east-1a
- Public Subnet 2: us-east-1b

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
## Terraform State Management

To store the Terraform state file securely and prevent concurrent modifications, an S3 backend with DynamoDB state locking is used.

**S3 Backend Configuration**

Create an S3 bucket named "flaskapp_statefiles" in the AWS account to store Terraform state files.

Enable versioning on the bucket to maintain the history of state files.

**DynamoDB State Lock**

Create a DynamoDB table named "tf-state-lock" to manage state locking.

Set "LockID" as the partition key.

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
