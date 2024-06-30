# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set environment variables to prevent Python from writing pyc files to disk and to buffer stdout and stderr
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create a directory for the app inside the Docker container
WORKDIR /app

# Copy the requirements.txt file to the app directory in the Docker container
COPY requirements.txt /app/

# Install the Python dependencies listed in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the app directory in the Docker container
COPY . /app/

# Set an environment variable to specify the entry point for the Flask application
ENV FLASK_APP=app.py

# Expose the port that the Flask app will run on
EXPOSE 5000

# Set default environment variables for DynamoDB (optional, for local development)
ENV DYNAMODB_TABLE=reversed_ips
ENV AWS_REGION=us-east-1
ENV PORT=5000

# Specify the command to run the Flask app
CMD ["python3", "app.py"]
