# Project Overview

This repository contains the necessary files to build, deploy, and manage a Flask-based web application using Docker, Terraform, and Jenkins.

## Directory Structure

### 1. `app/`

- Contains the `Dockerfile` and Python script to containerize the Flask application.
- The Flask application listens on port `5000`.

### 2. `terraform/`

- Defines the infrastructure on AWS using Terraform.
- Creates the following resources:
  - VPC
  - 2 Public and 2 Private Subnets
  - Internet Gateway
  - NAT Gateway
  - Route Tables
  - ECS Cluster
  - Application Load Balancer (ALB)
  - S3 Backend for Terraform state storage
  - DynamoDB for state locking

### 3. `pipeline/`

- Contains the `Jenkinsfile` that automates the deployment process:
  - Builds the Docker image
  - Pushes the image to the container registry with the build number as the tag
  - Deploys the application to ECS
  - Ensures the ECS task runs the Flask application behind an ALB
  - Configures the ALB to listen on port `80` and forward requests to ECS tasks on port `5000`

## Application Access

- Once deployed, accessing the ALB's DNS name in the browser displays a web page showing the timestamp and the requester's IP address.

