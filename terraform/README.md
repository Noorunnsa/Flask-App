# Setting Up Infrastructure with Terraform

## Prerequisites

1. Clone the repository and navigate to the `terraform` directory inside it.

```bash
 git clone <repo-url>
 cd <repo-name>/terraform
```

2. Create an IAM user on AWS and download the `.csv` file containing the access keys.

3. Configure AWS credentials:

Create a file at `/home/ubuntu/terraform/.aws/credentials` and add the following content:

```ini
[default]
aws_access_key_id=<access_key>
aws_secret_access_key=<secret_access_key>
```

Export the credentials file:

```bash
export AWS_SHARED_CREDENTIALS_FILE=/home/ubuntu/terraform/.aws/credentials
```

> **Note:** Ensure that the `.aws` directory is in the same location where the Terraform files are stored.

## IAM Policy Configuration

Follow the **least privilege principle** and attach only the necessary policies to the IAM user for Terraform execution.

Attach the following policies to the IAM user:
- `AmazonVPCFullAccess`
- `IAMFullAccess`
- `AmazonEC2FullAccess`
- `AmazonECS_FullAccess`

### Resolving Authorization Issues

At some point, you may encounter the following error:

```
Unauthorized to perform: application-autoscaling:ListTagsForResource
```

Attempting to attach the `ApplicationAutoscalingFullAccess` policy results in the error:

```
Failed to add AWSApplicationAutoscalingECSServicePolicy to user.
Cannot attach AWS reserved policy to an IAM user.
```

To resolve this, create a custom inline policy named `custom-application-autoscaling` with the following JSON:

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
sh ./install-terraform.sh
```

## Deploying the Infrastructure

1. Initialize Terraform and validate the configuration:

```bash
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
**Congratulations!** You have successfully deployed infrastructure using Terraform. 🎉

