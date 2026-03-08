#!/bin/bash
# Deploy landing page with token address
# Usage: ./deploy-page.sh <TOKEN_ADDRESS>

set -e

TOKEN_ADDRESS=$1

if [ -z "$TOKEN_ADDRESS" ]; then
  echo "❌ Usage: ./deploy-page.sh <TOKEN_ADDRESS>"
  exit 1
fi

echo "🌐 Deploying landing page..."
echo "Token: $TOKEN_ADDRESS"
echo ""

# Update HTML with token address
echo "📝 Updating index.html..."
sed -i.bak "s/REPLACE_WITH_TOKEN_ADDRESS/$TOKEN_ADDRESS/g" index.html
rm index.html.bak

# Commit changes
echo "📦 Committing changes..."
git add index.html
git commit -m "Launch: Add token address $TOKEN_ADDRESS"

# Push to GitHub (triggers auto-deploy)
echo "🚀 Deploying..."
git push

echo ""
echo "✅ Landing page deployed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "View at: https://ckorhonen.github.io/symphony-pump"
echo "Or: https://symphony-pump.vercel.app (if Vercel configured)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
