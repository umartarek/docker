# Use a Python base image
FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies (MariaDB client, Redis, Node.js, npm, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-client \
    redis-server \
    curl \
    wget \
    git \
    nodejs \
    npm \
    python3-dev \
    libmariadb-dev \
    netcat \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install required Python packages for Frappe
RUN pip install --upgrade pip
RUN pip install frappe-bench

# Create a directory for the bench
WORKDIR /home/frappe

# Initialize Bench and create a new Frappe site automatically
RUN bench init frappe-bench --frappe-branch version-13 \
    && cd frappe-bench \
    && bench new-site frappe.local --mariadb-root-password root --admin-password admin --force \
    && bench get-app erpnext --branch version-13 \
    && bench --site frappe.local install-app erpnext

# Expose port for Frappe web server
EXPOSE 8000

# Start Frappe server and Redis when the container starts
CMD service redis-server start && bench start
