#!/bin/bash
# Generate all visual assets for Symphony launch
# This script coordinates logo generation, social graphics, and marketing materials

set -e

echo "🎨 Symphony Asset Generator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$PROJECT_ROOT"

# Create asset directories
mkdir -p assets/{logos,social,infographics,memes,banners}

echo "📁 Asset directories created"
echo ""

# Step 1: Generate primary logo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 1: Primary Logo Generation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -f "assets/logos/symphony-logo-512.png" ]; then
    echo "🎨 Generating logo..."
    
    # Try automated generation first
    if command -v claude &> /dev/null; then
        echo "   Using Claude Code CLI + nano-banana MCP..."
        
        LOGO_PROMPT=$(cat prompts/logo.txt)
        
        claude mcp call nano-banana gemini_generate_image \
            --prompt "$LOGO_PROMPT" \
            --imageSize "1K" \
            --output "assets/logos/symphony-logo-512.png" 2>/dev/null || {
            echo "   ⚠️  Automated generation failed"
            echo ""
            echo "   Manual generation required:"
            echo "   1. Visit: https://aistudio.google.com/prompts/new_freeform"
            echo "   2. Paste prompt from: prompts/logo.txt"
            echo "   3. Download image"
            echo "   4. Save as: assets/logos/symphony-logo-512.png"
            echo ""
            read -p "   Press Enter when logo is ready..."
        }
    else
        echo "   ℹ️  Automated generation not available"
        echo ""
        echo "   Manual generation options:"
        echo ""
        echo "   Option A: Google AI Studio (Free)"
        echo "     1. Visit: https://aistudio.google.com/prompts/new_freeform"
        echo "     2. Paste prompt from: prompts/logo.txt"
        echo "     3. Save as: assets/logos/symphony-logo-512.png"
        echo ""
        echo "   Option B: Other AI tools"
        echo "     • DALL-E: https://openai.com/dall-e"
        echo "     • Midjourney: https://midjourney.com"
        echo "     • Use prompt from: prompts/logo.txt"
        echo ""
        echo "   Fallback: Use 🎭 emoji as temporary logo"
        echo ""
        read -p "   Press Enter when logo is ready..."
    fi
    
    if [ -f "assets/logos/symphony-logo-512.png" ]; then
        echo "   ✅ Logo generated!"
    else
        echo "   ❌ Logo not found. Cannot continue."
        exit 1
    fi
else
    echo "✅ Logo already exists"
fi

echo ""

# Step 2: Create logo variants (different sizes)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 2: Logo Variants (Resizing)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if command -v convert &> /dev/null; then
    echo "📐 Creating logo variants..."
    
    BASE_LOGO="assets/logos/symphony-logo-512.png"
    
    # High-res
    convert "$BASE_LOGO" -resize 1024x1024 "assets/logos/symphony-logo-1024.png"
    echo "   ✅ 1024x1024"
    
    # Medium
    convert "$BASE_LOGO" -resize 256x256 "assets/logos/symphony-logo-256.png"
    echo "   ✅ 256x256"
    
    # Small
    convert "$BASE_LOGO" -resize 128x128 "assets/logos/symphony-logo-128.png"
    echo "   ✅ 128x128"
    
    # Tiny
    convert "$BASE_LOGO" -resize 64x64 "assets/logos/symphony-logo-64.png"
    echo "   ✅ 64x64"
    
    echo ""
    echo "✅ All logo variants created"
    
else
    echo "⚠️  ImageMagick not installed - skipping resize"
    echo "   Install: brew install imagemagick"
    echo "   (Logo variants can be created later)"
fi

echo ""

# Step 3: Social media templates
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "STEP 3: Social Media Graphics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📱 Generating social media templates..."
echo ""
echo "   These require manual creation or design tools:"
echo "   • Canva (https://canva.com)"
echo "   • Figma (https://figma.com)"  
echo "   • Photoshop/GIMP"
echo ""
echo "   Templates to create:"
echo "   [ ] Twitter header (1500x500)"
echo "   [ ] Discord banner (960x540)"
echo "   [ ] Open Graph image (1200x630)"
echo ""
echo "   Design guidelines:"
echo "   • Use Symphony logo (assets/logos/)"
echo "   • Color palette: Purple #8B5CF6, Cyan #06B6D4"
echo "   • Include tagline: 'AI Agent Orchestration'"
echo "   • Keep it minimal and professional"
echo ""

read -p "Skip social templates for now? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "   Waiting for manual creation..."
    echo "   Save files to assets/social/"
    read -p "   Press Enter when done..."
fi

echo ""

# Step 4: Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Asset Generation Complete"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Generated assets:"
ls -1 assets/logos/ 2>/dev/null | while read file; do
    echo "   ✅ logos/$file"
done

ls -1 assets/social/ 2>/dev/null | while read file; do
    echo "   ✅ social/$file"
done

echo ""
echo "Ready for launch: $(ls -1 assets/logos/*.png 2>/dev/null | wc -l | tr -d ' ')/5 logo variants"
echo ""

echo "Next steps:"
echo "  1. Review assets in assets/ directory"
echo "  2. (Optional) Create social media graphics"
echo "  3. Test deployment: npm run deploy-token"
echo ""
