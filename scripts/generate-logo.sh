#!/bin/bash
# Generate Symphony logo using nano-banana MCP
# This script can be run manually or automated

set -e

PROMPT=$(cat prompts/logo.txt)
OUTPUT_DIR="./assets/logos"
mkdir -p "$OUTPUT_DIR"

echo "🎨 Generating Symphony logo..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Option 1: Via Claude Code CLI with nano-banana MCP
if command -v claude &> /dev/null; then
    echo "Using Claude Code CLI + nano-banana MCP..."
    
    claude mcp call nano-banana gemini_generate_image \
        --prompt "$PROMPT" \
        --imageSize "1K" \
        --output "$OUTPUT_DIR/symphony-logo-512.png"
    
    echo "✅ Logo generated: $OUTPUT_DIR/symphony-logo-512.png"
    
else
    echo "❌ Claude Code CLI not found"
    echo ""
    echo "Alternative: Generate manually"
    echo "1. Visit: https://aistudio.google.com/prompts/new_freeform"
    echo "2. Use prompt from: prompts/logo.txt"
    echo "3. Save as: $OUTPUT_DIR/symphony-logo-512.png"
    echo ""
    echo "Or install Claude Code CLI:"
    echo "  npm install -g @anthropic/claude-code"
    exit 1
fi

# Create additional sizes
if [ -f "$OUTPUT_DIR/symphony-logo-512.png" ]; then
    echo ""
    echo "📐 Creating additional sizes..."
    
    # Requires ImageMagick
    if command -v convert &> /dev/null; then
        convert "$OUTPUT_DIR/symphony-logo-512.png" -resize 256x256 "$OUTPUT_DIR/symphony-logo-256.png"
        convert "$OUTPUT_DIR/symphony-logo-512.png" -resize 128x128 "$OUTPUT_DIR/symphony-logo-128.png"
        convert "$OUTPUT_DIR/symphony-logo-512.png" -resize 64x64 "$OUTPUT_DIR/symphony-logo-64.png"
        convert "$OUTPUT_DIR/symphony-logo-512.png" -resize 1024x1024 "$OUTPUT_DIR/symphony-logo-1024.png"
        
        echo "✅ Created sizes: 64, 128, 256, 512, 1024"
    else
        echo "⚠️  ImageMagick not installed - skipping resize"
        echo "   Install: brew install imagemagick"
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Logo generation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
