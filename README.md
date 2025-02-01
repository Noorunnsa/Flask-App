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
  "time": "2024-07-01T12:34:56Z",
  "timezone": "UTC"
}
```

## Prerequisites
To run this project, you need:
- Docker installed on your system
- Git for cloning the repository
- An EC2 instance (if deploying on AWS)

## Installation and Setup
1. **Clone the Repository**
   ```bash
   git clone <repository_url>
   cd <repository_name>/app
   ```

2. **Build the Docker Image**
   ```bash
   docker build -t noorunnisa/flask-app:latest .
   ```

3. **Run the Docker Container**
   ```bash
   docker run -d -p 5000:5000 <image-id>
   ```

4. **Access the Service**
   Open a browser or use `curl` to check the response:
   ```bash
   curl http://<public_ip_EC2>:5000/
   ```

## Security Best Practices
- **Minimal Base Image**: The Docker image uses `alpine:3.21` to keep it lightweight and reduce vulnerabilities.
- **Optimized Image Layers**: `RUN` commands are combined to minimize layers and improve efficiency.
- **Non-Root User**: The container runs as a non-root user (`appuser`) to enhance security.

## Environment Variables
You can configure the service using the following environment variables:
- `PORT`: The port on which the service runs (default: `5000`)
- `TIMEZONE`: The timezone to display time in (default: `UTC`)

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


