#!/bin/bash
# Pre-flight Launch Checklist
# Run this the morning of launch to verify everything is ready

set -e

echo "🎭 SYMPHONY PRE-FLIGHT CHECK"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will verify all requirements before launch."
echo ""

ERRORS=0
WARNINGS=0

# Helper functions
check_pass() {
    echo "✅ $1"
}

check_fail() {
    echo "❌ $1"
    ((ERRORS++))
}

check_warn() {
    echo "⚠️  $1"
    ((WARNINGS++))
}

# Environment checks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1. ENVIRONMENT"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    check_pass "Node.js installed ($NODE_VERSION)"
else
    check_fail "Node.js not found"
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    check_pass "npm installed ($NPM_VERSION)"
else
    check_fail "npm not found"
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    check_pass "Git installed ($GIT_VERSION)"
else
    check_fail "Git not found"
fi

# Check dependencies installed
if [ -d "node_modules" ]; then
    check_pass "Node modules installed"
else
    check_fail "Node modules missing (run: npm install)"
fi

# Check ImageMagick (optional)
if command -v convert &> /dev/null; then
    check_pass "ImageMagick installed (logo resizing available)"
else
    check_warn "ImageMagick not installed (logo resizing unavailable)"
fi

echo ""

# File checks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "2. REQUIRED FILES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check scripts
if [ -f "scripts/deploy-token.js" ]; then
    check_pass "deploy-token.js exists"
else
    check_fail "deploy-token.js missing"
fi

if [ -f "scripts/post-tweets.js" ]; then
    check_pass "post-tweets.js exists"
else
    check_fail "post-tweets.js missing"
fi

if [ -f "scripts/monitor.js" ]; then
    check_pass "monitor.js exists"
else
    check_fail "monitor.js missing"
fi

if [ -f "scripts/deploy-page.sh" ]; then
    check_pass "deploy-page.sh exists"
else
    check_fail "deploy-page.sh missing"
fi

# Check prompts
if [ -f "prompts/logo.txt" ]; then
    check_pass "Logo prompt exists"
else
    check_fail "Logo prompt missing"
fi

if [ -f "prompts/tweet-thread.txt" ]; then
    check_pass "Tweet template exists"
else
    check_fail "Tweet template missing"
fi

if [ -f "prompts/description.txt" ]; then
    check_pass "Token description exists"
else
    check_fail "Token description missing"
fi

# Check landing page
if [ -f "index.html" ]; then
    check_pass "Landing page exists"
else
    check_fail "Landing page missing"
fi

echo ""

# Logo check
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "3. LOGO"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "assets/logos/symphony-logo-512.png" ]; then
    check_pass "Logo exists (assets/logos/symphony-logo-512.png)"
    
    # Check file size
    SIZE=$(stat -f%z "assets/logos/symphony-logo-512.png" 2>/dev/null || stat -c%s "assets/logos/symphony-logo-512.png" 2>/dev/null)
    if [ "$SIZE" -gt 1000 ]; then
        check_pass "Logo file size OK (${SIZE} bytes)"
    else
        check_warn "Logo file seems small (${SIZE} bytes)"
    fi
else
    check_warn "Logo not generated yet"
    echo "   Generate now: ./scripts/generate-all-assets.sh"
    echo "   Or use fallback: see FALLBACK_LOGO.md"
fi

echo ""

# Configuration check
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "4. CONFIGURATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f ".env" ]; then
    check_pass ".env file exists"
    
    # Check key variables
    if grep -q "HEADLESS=" ".env"; then
        check_pass "HEADLESS configured"
    else
        check_warn "HEADLESS not set in .env"
    fi
    
    if grep -q "AUTO_BUY=" ".env"; then
        check_pass "AUTO_BUY configured"
    else
        check_warn "AUTO_BUY not set in .env"
    fi
else
    check_warn ".env file missing (copy from .env.example)"
fi

echo ""

# Git check
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "5. GIT REPOSITORY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if git repo
if [ -d ".git" ]; then
    check_pass "Git repository initialized"
    
    # Check if clean
    if [ -z "$(git status --porcelain)" ]; then
        check_pass "Working directory clean"
    else
        check_warn "Uncommitted changes exist"
    fi
    
    # Check remote
    if git remote -v | grep -q "origin"; then
        REMOTE=$(git remote get-url origin)
        check_pass "Remote configured ($REMOTE)"
    else
        check_warn "No remote configured"
    fi
else
    check_fail "Not a git repository"
fi

echo ""

# Manual checks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "6. MANUAL VERIFICATION REQUIRED"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "⏸️  Phantom Wallet:"
echo "   [ ] Installed and unlocked"
echo "   [ ] Has 10+ SOL"
echo "   [ ] Connected to pump.fun at least once"
echo "   [ ] Is a burner wallet (not main stack)"
echo ""

echo "⏸️  Twitter Account:"
echo "   [ ] Logged in"
echo "   [ ] Bio mentions AI agents"
echo "   [ ] Ready to post thread"
echo ""

echo "⏸️  GitHub Pages:"
echo "   [ ] Enabled in repo settings"
echo "   [ ] Custom domain configured (if using)"
echo ""

echo "⏸️  Timing:"
echo "   [ ] Launching at optimal time (10am-12pm EST or 6pm-8pm EST)"
echo "   [ ] Not Friday evening or Sunday night"
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ ALL CHECKS PASSED"
    echo ""
    echo "Ready to launch! Run:"
    echo "  npm run autonomous-launch"
    echo ""
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  WARNINGS: $WARNINGS"
    echo ""
    echo "You can proceed, but review warnings above."
    echo "Ready when you are:"
    echo "  npm run autonomous-launch"
    echo ""
else
    echo "❌ ERRORS: $ERRORS"
    echo "⚠️  WARNINGS: $WARNINGS"
    echo ""
    echo "Fix errors above before launching."
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
