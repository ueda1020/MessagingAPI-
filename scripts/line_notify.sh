#!/bin/bash

TOKEN="$1"
TO="$2"
MSG="$3"

BODY=$(jq -n --arg to "$TO" --arg msg "$MSG" \
  '{to:$to, messages:[{type:"text", text:$msg}]}')

echo "Sending LINE notification..."
echo "To: $TO"
echo "Message: $MSG"
echo "Request Body: $BODY"

# Send the request and capture the response and HTTP status code
RESPONSE=$(curl -sS -w "%{http_code}" -o /tmp/response_body.txt -X POST "https://api.line.me/v2/bot/message/push" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "$BODY")

HTTP_STATUS=$(tail -n1 <<< "$RESPONSE")
RESPONSE_BODY=$(cat /tmp/response_body.txt)

# Display the API response
echo "HTTP Status: $HTTP_STATUS"
echo "Response Body: $RESPONSE_BODY"

# Check if the HTTP status is not 200
if [ "$HTTP_STATUS" -ne 200 ]; then
  echo "Warning: LINE notification failed with status $HTTP_STATUS"
  echo "Continuing with the next steps..."
else
  echo "Notification sent successfully."
fi
