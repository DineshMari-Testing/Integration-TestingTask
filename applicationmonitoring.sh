#!/bin/bash

# Configuration
APPLICATION_URL="http://localhost:8080" # Replace with the URL of your application
EXPECTED_STATUS_CODE=200
EMAIL="maridinesh2202@gmail.com"

# Function to send email alert
send_alert() {
    local status=$1
    local subject="Application Status Alert"
    local body="The application is currently $status. Please check the application at $APPLICATION_URL."
    echo "$body" | mail -s "$subject" "$EMAIL"
}

# Check the application's status
response_code=$(curl -o /dev/null -s -w "%{http_code}\n" "$APPLICATION_URL")

# Determine if the application is up or down
if [ "$response_code" -eq "$EXPECTED_STATUS_CODE" ]; then
    echo "Application is UP."
else
    echo "Application is DOWN. HTTP Status Code: $response_code"
    send_alert "DOWN"
fi

