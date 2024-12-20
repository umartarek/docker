#!/bin/bash

# Wait for MariaDB and Redis to be available
echo "Waiting for MariaDB and Redis to start..."
until mysqladmin ping -h db --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

until redis-cli -h redis ping; do
    echo "Waiting for Redis..."
    sleep 2
done

# Initialize Bench and Frappe
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
