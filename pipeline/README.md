# Flask-App CI/CD Pipeline

This pipeline builds a Docker image, tags it with the build number, and pushes it to the registry. It then provisions the required infrastructure using terraform on AWS and deploys the latest image to an ECS task, with an Application Load Balancer (ALB) in front.

## Getting Started

1. **Launch EC2 Instance**:
   - Instance Type: `t3.medium`
   - OS: Ubuntu 22.04 LTS
   - Disk Size: 20GB
   - Security Group: Open port `8080` for Jenkins web UI and `22` for SSH access.

2. **Clone the repository**
   - Clone the git repository and navigate to the `Flask-App/pipeline` directory.

      ```bash
      cd /home/ubuntu
      git clone https://github.com/Noorunnsa/Flask-App.git
      cd Flask-App/pipeline
     ```
2. **Install Jenkins**:
   - Run the following commands to install Jenkins:

     ```bash
     chmod +x install-jenkins.sh
     sh ./install-jenkins.sh
     ```

3. **Post Installation Setup**:
   - Access Jenkins via the browser at `http://<EC2_PUBLIC_IP>:8080`.
   - Complete the Jenkins post-installation setup wizard.

4. **Update Security Group**:
   - In the EC2 instance security group, add an inbound rule allowing custom TCP traffic on port `8080` for Jenkins.

5. **Add Jenkins User to Docker Group**:
   - Add the Jenkins user to the Docker group so Jenkins can run Docker commands:
     
     ```bash
     sudo usermod -aG docker jenkins
     ```

   - Restart Jenkins after adding the user to the Docker group:
     
     ```bash
     sudo systemctl restart jenkins 
     ```

6. **Install AWS Credentials Plugin**:
   - From the Jenkins dashboard, go to `Manage Jenkins > Plugins > Available Plugins`.
   - Install the `AWS Credentials Plugin` for managing AWS credentials securely.

7. **DockerHub Credentials**
   - Configure the DockerHub credentials of type **Username and Password** and give ID as `dockerHubCredentials` to authenticate with DockerHub and push/pull images. 

8. **AWS IAM Credentials**
   - Configure the AWS IAM credentials of type **AWS Credentials** and give ID as 'aws-credentials' for Terraform to interact with AWS services. The  type "AWS Credentials" is provided by the `AWS Credentials Plugin`.


## Usage

1. **Create a Jenkins Job**:
   - Create a new `Pipeline` job in Jenkins.
   - In the pipeline configuration, point the `Jenkinsfile` to the `pipeline/Jenkinsfile` directory in your repository.

2. **Run the Pipeline**:
   - Trigger the pipeline. The pipeline will execute the stages outlined below, from building the Docker image to deploying the Flask app to AWS.
  

## Pipeline Stages Overview
  
### 1. **Checkout main branch**
   - The pipeline starts by checking out the latest code from the `main` branch of the Flask-App repository.

### 2. **Build Docker Image**
   - Using the `Dockerfile` present in the `app` directory, the pipeline builds a Docker image tagged with the Jenkins build number and the DockerHub username.

### 3. **Login to DockerHub and Push Docker Image**
   - Jenkins logs into DockerHub using the `dockerHubCredentials` stored in Jenkins credentials and pushes the built image to DockerHub.

### 4. **Initialize Terraform**
   - The pipeline runs Terraform initialization in the `terraform` directory, setting up the required backend and providers.

### 5. **Update Container Image Tag in `terraform.tfvars`**
   - The pipeline updates the `terraform.tfvars` file with the new Docker image tag (`flask-app:${BUILD_NUMBER}`), which is used for the deployment in ECS.

### 6. **Terraform Plan**
   - A Terraform plan is generated to show the infrastructure changes that will be made, based on the updated `terraform.tfvars`.

### 7. **Manual Approval**
   - A manual approval step is included between the `plan` and `apply` stages to ensure that changes are reviewed before they are applied to production.

### 8. **Terraform Apply**
   - The Terraform apply stage executes the changes from the plan stage, deploying the Flask app to AWS.

### 9. **Terraform Output**
   - After applying the changes, the pipeline outputs the DNS name of the Application Load Balancer (ALB) associated with the deployed Flask app.
 
 Open the provided URL in the browser to access the Flask application.

## Notes

- Ensure that the AWS IAM credentials provided to Jenkins have sufficient permissions.
- If not yet, follow the README.md file in the Flask-App/terraform/ directory of this repository to attach the required IAM policies to the IAM user.
- The pipeline assumes that the DockerHub and AWS credentials are already configured in Jenkins as `dockerHubCredentials` (with **Username and Password** type) and `aws-credentials` (with **AWS Credentials** type), respectively.

## Conclusion

This pipeline automates the process of building and deploying the Flask app using Docker and Terraform. With the manual approval step and Terraform integration, it ensures a controlled and reliable deployment process to AWS.
