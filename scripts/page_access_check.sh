#!/bin/bash

URL="https://hu-udsystem.com/gateway/"
LOGIN_URL="https://hu-udsystem.com/gateway/logon/"
USERNAME="$1"
PASSWORD="$2"

# Initialize PAGE_ACCESSIBLE to prevent undefined errors
PAGE_ACCESSIBLE=false

# Check page accessibility
echo "Checking access to $URL ..."
if curl --silent --head --fail "$URL" > /dev/null; then
  echo "Page is Accessible"

  # Attempt login if page is accessible
  echo "Attempting login..."
  CSRF=$(curl -s -c cookies.txt "$URL" | grep -oP '(?<=name="csrfmiddlewaretoken" value=").*?(?=")')
  if [ -n "$CSRF" ]; then
    RESPONSE=$(curl -s -b cookies.txt -c cookies.txt \
      -d "csrfmiddlewaretoken=${CSRF}&user_id=${USERNAME}&pwd=${PASSWORD}" \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -e "$URL" \
      -X POST "$LOGIN_URL" \
      -w "HTTPSTATUS:%{http_code}")

    HTTP_CODE=$(echo "$RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')
    BODY=$(echo "$RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')

    if [ "$HTTP_CODE" = "200" ] && echo "$BODY" | grep -q "ビルダー"; then
      echo "Login successful"
      PAGE_ACCESSIBLE=true
    else
      echo "Login failed (HTTP $HTTP_CODE)"
    fi
  else
    echo "CSRF token not found"
  fi
else
  echo "Page is not accessible"
fi

# GitHub Actionsの$GITHUB_OUTPUTに書き込む
echo "page_accessible=$PAGE_ACCESSIBLE" >> "$GITHUB_OUTPUT"
