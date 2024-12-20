#!/bin/bash

# Function to wait for a service
wait_for_service() {
  local host=$1
  local port=$2
  local name=$3

  echo "Waiting for $name to start..."
  while ! nc -z $host $port; do
    echo "Waiting for $name..."
    sleep 2
  done
  echo "$name is ready."
}

# Wait for MariaDB and Redis
wait_for_service "db" 3306 "MariaDB"
wait_for_service "redis" 6379 "Redis"

# Initialize Bench and Frappe if not already done
if [ ! -d "frappe-bench" ]; then
  echo "Initializing Frappe Bench..."
  bench init frappe-bench --frappe-branch version-13
  cd frappe-bench
  bench new-site frappe.local --mariadb-root-password root --admin-password admin
  bench get-app erpnext --branch version-13
  bench --site frappe.local install-app erpnext
else
  echo "Frappe Bench already initialized."
  cd frappe-bench
fi

# Start Frappe
bench start
