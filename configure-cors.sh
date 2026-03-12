#!/bin/bash

# Firebase Storage CORS Configuration Script
# This script configures CORS for your Firebase Storage bucket

echo "🔧 Configuring CORS for Firebase Storage..."
echo ""
echo "Please follow these steps:"
echo ""
echo "1. Go to Google Cloud Console: https://console.cloud.google.com/storage/browser"
echo "2. Log in and select project: kirana-konu"
echo "3. Click on bucket: kirana-konu.firebasestorage.app"
echo "4. Click the 'Permissions' tab"
echo "5. Click 'Grant Access'"
echo "6. Add new principal: allUsers"
echo "7. Select role: Storage Object Viewer"
echo "8. Click Save"
echo ""
echo "OR use this CORS configuration file I created: cors.json"
echo ""
echo "To apply via gsutil (after installing Google Cloud SDK):"
echo "  gsutil cors set cors.json gs://kirana-konu.firebasestorage.app"
echo ""
