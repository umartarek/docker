# Use the official Python image as the base
FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    mariadb-client \
    redis-server \
    curl \
    wget \
    git \
    nodejs \
    npm \
    python3-dev \
    libmariadb-dev \
    && apt-get clean

# Install Bench CLI
RUN pip install frappe-bench

# Create a working directory for Frappe
WORKDIR /frappe

# Initialize Bench and install Frappe
RUN bench init frappe-bench --frappe-branch version-13 \
    && cd frappe-bench \
    && bench new-site frappe.local --mariadb-root-password root --admin-password admin \
    && bench get-app erpnext --branch version-13 \
    && bench --site frappe.local install-app erpnext

# Expose the default Frappe port
EXPOSE 8000

# Start Frappe
CMD ["bench", "start"]
