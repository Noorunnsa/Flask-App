# Use the official Python image from Docker Hub
FROM python:alpine3.21

# Create a new user (non-root) named 'appuser'
# Create a directory named '/app'
# Change ownership of the app files to the non-root user
# Install Flask and any dependencies required for the app
RUN adduser -D -u 1000 appuser && \
    mkdir -p /app && \
    chown -R appuser:appuser /app && \
    pip install --no-cache-dir flask


# Set the working directory in the container
WORKDIR /app

# Copy the local app files into the container's working directory
COPY . /app

# Switch to the non-root user
USER appuser

# Expose the port that the app will run on (5000 in this case)
EXPOSE 5000

# Set the command to run your Flask app
CMD ["python3", "app.py"]

