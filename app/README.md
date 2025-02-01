# Flask-App
A simple Flask web application containerized using Docker. This app displays the current timestamp and the IP address of the requester.

# SimpleTimeService - Tiny App Development

## Overview
SimpleTimeService is a lightweight microservice that provides the current server time in JSON format. It is built using Flask (Python) and runs as a web server, responding to requests with a simple JSON payload.

## Features
- Returns the current server time in a JSON response
- Lightweight and easy to deploy
- Containerized with Docker for easy distribution
- Security best practices implemented

## JSON Response Structure
When accessing the root URL (`/`), the service returns a response in the following format:

```json
{
   "ip": "10.0.102.201",
  "timestamp": "2025-02-01T11:11:19.594500"
}
```

## Prerequisites
To run this project, you need:
- Docker installed on your system
- Git for cloning the repository
- An EC2 instance (ubuntu 22.04 lts, t2.micro, 8 GB)

## Installation and Setup
   
1. **Clone the Repository**
   ```bash
   git clone https://github.com/Noorunnsa/Flask-App.git
   cd Flask-App/
   ```
2. **Install Docker**
   ```bash
   cd app
   chmod +x docker-install.sh
   sh ./docker-install.sh
   systemctl enable --now docker
   systemctl status docker
   ```

3. **Build the Docker Image**
   ```bash
   docker build -t noorunnisa/flask-app:latest .
   ```
4. **Allow Traffic on port 5000**
   
   Allow inbound traffic on port 5000 using a custom TCP rule in the EC2 instance's security group settings.
   
5. **Run the Docker Container**
   ```bash
   docker run -d -p 5000:5000 <image-id>
   ```

6. **Access the Service**
   Open a browser or use `curl` to check the response:
   ```bash
   curl http://<ec2_public_ip>:5000/
   ```

## Security Best Practices
- **Minimal Base Image**: The Docker image uses `alpine:3.21` to keep it lightweight and reduce vulnerabilities.
- **Optimized Image Layers**: `RUN` commands are combined to minimize layers and improve efficiency.
- **Non-Root User**: The container runs as a non-root user (`appuser`) to enhance security.

## Stopping the Service
To stop the container, use:
```bash
docker ps  # Get the container ID
docker stop <container_id>
```

## License
This project is open-source and available under the MIT License.

## Author
Noorunnisa
