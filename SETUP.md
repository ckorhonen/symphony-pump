# 🚀 Symphony Launch System - Setup Guide

Complete setup instructions for autonomous token launch.

---

## Prerequisites

### 1. Software Requirements

```bash
# Node.js 18+ (check version)
node --version

# Bun (alternative to npm)
bun --version

# Git
git --version

# ImageMagick (optional, for logo resizing)
brew install imagemagick
```

### 2. Wallet Setup

1. Install [Phantom Wallet](https://phantom.app/)
2. Create or import wallet
3. Fund with ~10 SOL:
   - 5 SOL for initial buy
   - 5 SOL buffer for gas + testing
4. Visit [pump.fun](https://pump.fun) and connect wallet once

### 3. Dependencies

```bash
cd symphony-pump

# Install Node.js dependencies
npm install

# Or with Bun
bun install
```

---

## Configuration

### Environment Variables

Create `.env` file:

```bash
cp .env.example .env
```

Edit `.env`:

```bash
# Required
HEADLESS=false  # Set to true for headless browser (after first run)
AUTO_BUY=true   # Auto-execute initial buy
INITIAL_BUY_SOL=5  # Amount to buy

# Optional - Twitter API (for auto-posting)
TWITTER_API_KEY=
TWITTER_API_SECRET=
TWITTER_ACCESS_TOKEN=
TWITTER_ACCESS_SECRET=

# Optional - Gemini API (for logo generation)
GEMINI_API_KEY=
```

---

## Quick Start

### Option A: Full Autonomous Launch

```bash
npm run autonomous-launch
```

This will:
1. Generate logo
2. Deploy token
3. Prepare tweets
4. Deploy landing page
5. Start monitoring

**Time:** ~15-20 minutes (including wallet approvals)

### Option B: Step-by-Step Manual

```bash
# 1. Generate logo
npm run generate-logo

# 2. Deploy token
npm run deploy-token

# 3. Prepare tweets
npm run post-tweets

# 4. Deploy landing page
npm run deploy-page

# 5. Start monitoring
npm run monitor
```

---

## Detailed Steps

### 1. Logo Generation

**Automatic (requires nano-banana MCP or Gemini API):**
```bash
npm run generate-logo
```

**Manual Alternative:**
1. Use AI image generator (DALL-E, Midjourney, etc.)
2. Use prompt from `prompts/logo.txt`
3. Save as `assets/logos/symphony-logo-512.png`

**Output:**
- `assets/logos/symphony-logo-512.png` (main)
- `assets/logos/symphony-logo-*.png` (various sizes)

### 2. Token Deployment

```bash
npm run deploy-token
```

**What happens:**
- Browser opens pump.fun
- Form auto-fills with token details
- Waits for you to approve transaction in Phantom
- Saves token address to `.token-address`

**Note:** First run requires visible browser (`HEADLESS=false`)

### 3. Tweet Thread

```bash
npm run post-tweets
```

**Outputs:**
- `twitter-thread-formatted.txt` (formatted for posting)
- Console displays each tweet with character counts

**Manual posting:**
1. Copy tweet 1, post to Twitter
2. Pin tweet 1 to profile
3. Post tweets 2-6 as replies

**Auto-posting** (if Twitter API configured):
- Set credentials in `.env`
- Thread posts automatically

### 4. Landing Page

```bash
npm run deploy-page <TOKEN_ADDRESS>
```

Or after token deployment:
```bash
npm run deploy-page $(cat .token-address)
```

**What happens:**
- Updates `index.html` with token address
- Commits to git
- Pushes to GitHub (auto-deploys via Pages)

### 5. Monitoring

```bash
npm run monitor
```

**Features:**
- Real-time price, holders, volume
- Milestone detection (50, 100, 250... holders)
- Auto-tweet suggestions
- Runs continuously (Ctrl+C to stop)

---

## Troubleshooting

### "Logo not found"

**Solution:**
```bash
npm run generate-logo
# Or place manually at: assets/logos/symphony-logo-512.png
```

### "Wallet not connected"

**Solution:**
1. Open pump.fun manually
2. Connect Phantom wallet
3. Run deploy script again

### "Transaction failed"

**Common causes:**
- Insufficient SOL balance
- Network congestion
- Wallet approval cancelled

**Solution:**
- Check wallet has 10+ SOL
- Try again (script is idempotent)
- Check Phantom for pending transactions

### Browser automation not working

**Solution:**
1. Set `HEADLESS=false` in `.env`
2. Watch browser to debug
3. Check Playwright is installed: `npm install playwright`

---

## File Structure

```
symphony-pump/
├── scripts/
│   ├── autonomous-launch.sh      # Main orchestrator
│   ├── deploy-token.js           # Browser automation
│   ├── post-tweets.js            # Tweet formatter/poster
│   ├── deploy-page.sh            # Landing page deployer
│   ├── monitor.js                # Price/holder monitor
│   └── generate-logo.sh          # Logo generator
├── prompts/
│   ├── logo.txt                  # Logo generation prompt
│   ├── tweet-thread.txt          # Tweet templates
│   └── description.txt           # Token description
├── assets/
│   └── logos/                    # Generated logos
├── index.html                    # Landing page
├── package.json                  # Dependencies & scripts
└── .env                          # Configuration
```

---

## Launch Checklist

**Before Launch:**
- [ ] Phantom wallet installed & funded (10 SOL)
- [ ] Dependencies installed (`npm install`)
- [ ] `.env` configured
- [ ] Logo generated (or ready to generate)
- [ ] Twitter account ready

**During Launch:**
- [ ] Run `npm run autonomous-launch`
- [ ] Approve wallet transactions
- [ ] Post tweets (auto or manual)
- [ ] Verify landing page live

**After Launch:**
- [ ] Monitor running
- [ ] Engage with early holders
- [ ] Post agent activity updates
- [ ] Execute weekly votes

---

## Advanced Usage

### Running Individual Components

```bash
# Just generate logo
npm run generate-logo

# Just deploy (if logo exists)
npm run deploy-token

# Just format tweets (if token deployed)
npm run post-tweets

# Just update landing page
npm run deploy-page $(cat .token-address)

# Just monitor
npm run monitor
```

### Headless Mode

After first successful run:

```bash
# Edit .env
HEADLESS=true

# Future deploys run headless
npm run deploy-token
```

### Custom Initial Buy

```bash
# Edit .env
INITIAL_BUY_SOL=10  # Buy 10 SOL instead of 5

# Or pass as environment variable
INITIAL_BUY_SOL=10 npm run deploy-token
```

---

## Security Notes

- ✅ Use dedicated burner wallet (not main stack)
- ✅ Never commit `.env` or private keys
- ✅ Review transactions before approving
- ❌ Don't run on untrusted networks
- ❌ Don't share wallet seed phrase

---

## Next Steps

After successful launch:

1. **Week 1:** Daily agent activity posts
2. **Week 2:** First governance vote
3. **Week 3:** Execute community choice
4. **Month 2:** Iterate based on feedback

See `LAUNCH_PACK_DEEP.md` for complete playbook.

---

## Support

**Issues?**
- Check BUILD_LOG.md for latest updates
- Review error screenshots (if generated)
- Check Phantom for pending transactions

**Questions?**
- See AUTONOMOUS_LAUNCH.md for architecture
- See LAUNCH_PACK_DEEP.md for strategy
- Open issue on GitHub

---

**Ready to launch? Run `npm run autonomous-launch` 🎭**
