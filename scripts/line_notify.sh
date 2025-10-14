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

curl -sS -X POST "https://api.line.me/v2/bot/message/push" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "$BODY"
