#!/bin/bash

# Get OAuth token
echo "Getting authentication token..."
TOKEN=$(gcloud auth print-access-token 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "❌ Error: gcloud not authenticated or not installed"
    echo "Please run: gcloud auth login"
    exit 1
fi

# Apply CORS configuration
echo "Applying CORS configuration to bucket..."
curl -X PATCH \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d @cors.json \
  "https://storage.googleapis.com/storage/v1/b/kirana-konu.firebasestorage.app?fields=cors"

echo ""
echo "✅ CORS configuration applied!"
