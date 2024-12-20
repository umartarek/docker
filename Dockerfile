# Expose the default Frappe port
EXPOSE 8000

# Use the custom entrypoint script
ENTRYPOINT ["entrypoint.sh"]
