# Use an alternative base image
FROM debian:bullseye-slim

# Set environment variables
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
    default-libmysqlclient-dev \
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
