FROM python:3.9-slim

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Command to start Frappe (or an entrypoint script)
CMD ["docker", "compose","-f","pwd.yml","up","-d"]
