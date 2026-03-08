#!/bin/bash
# Autonomous Symphony Token Launch
# Run by: Zora (AI agent)
# Zero human intervention required (after wallet setup)

set -e

echo "🎭 AUTONOMOUS SYMPHONY LAUNCH"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This script will:"
echo "  1. Generate logo"
echo "  2. Deploy token on pump.fun"
echo "  3. Prepare tweet thread"
echo "  4. Deploy landing page"
echo "  5. Start monitoring"
echo ""
echo "Prerequisites:"
echo "  ✅ Phantom wallet connected to pump.fun"
echo "  ✅ ~10 SOL in wallet"
echo "  ✅ Node.js dependencies installed (npm install)"
echo ""
read -p "Ready to launch? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Launch cancelled."
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 1: Logo Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -f "./assets/logos/symphony-logo-512.png" ]; then
    echo "🎨 Generating logo..."
    npm run generate-logo || {
        echo ""
        echo "⚠️  Logo generation failed"
        echo "   Please generate manually and place at:"
        echo "   ./assets/logos/symphony-logo-512.png"
        echo ""
        read -p "Press Enter when logo is ready..."
    }
else
    echo "✅ Logo already exists"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 2: Token Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -f "./.token-address" ]; then
    echo "🚀 Deploying token on pump.fun..."
    echo ""
    echo "⚠️  You will need to approve transactions in Phantom wallet"
    echo ""
    
    # Run with visible browser for first launch
    HEADLESS=false npm run deploy-token
    
    TOKEN_ADDR=$(cat ./.token-address)
    echo ""
    echo "✅ Token deployed: $TOKEN_ADDR"
else
    TOKEN_ADDR=$(cat ./.token-address)
    echo "✅ Token already deployed: $TOKEN_ADDR"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 3: Tweet Thread"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📝 Preparing tweet thread..."
npm run post-tweets

echo ""
echo "📋 Thread ready in: twitter-thread-formatted.txt"
echo ""
echo "🐦 Next: Post the thread manually to Twitter"
echo "   (Or configure Twitter API for auto-posting)"
echo ""
read -p "Press Enter when tweets are posted..."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 4: Landing Page Deployment"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "🌐 Deploying landing page..."
npm run deploy-page "$TOKEN_ADDR"

echo ""
echo "✅ Landing page live at:"
echo "   https://ckorhonen.github.io/symphony-pump"
echo "   (or your configured domain)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "PHASE 5: Monitoring"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "👀 Starting token monitor..."
echo "   (This will run continuously - Ctrl+C to stop)"
echo ""
echo "   Monitoring:"
echo "   • Price & market cap"
echo "   • Holder count"
echo "   • 24h volume"
echo "   • Milestone alerts"
echo ""

read -p "Start monitor now? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    npm run monitor
else
    echo "   Skipped. Run manually: npm run monitor"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ AUTONOMOUS LAUNCH COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📊 Summary:"
echo "   Token:   $TOKEN_ADDR"
echo "   Page:    https://ckorhonen.github.io/symphony-pump"
echo "   pump.fun: https://pump.fun/$TOKEN_ADDR"
echo ""
echo "🎯 Post-Launch Checklist:"
echo "   ✅ Token deployed"
echo "   ✅ Tweets posted"
echo "   ✅ Landing page live"
echo "   ⏳ Monitor running (or ready to run)"
echo ""
echo "🎭 The agent swarm is live. Let the chaos begin."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
