# Use the official Python image as the base
FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary system dependencies
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

# Install Bench CLI
RUN pip install frappe-bench

# Set working directory
WORKDIR /frappe

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the default Frappe port
EXPOSE 8000

# Use the custom entrypoint script
ENTRYPOINT ["entrypoint.sh"]
