# 🔧 Troubleshooting Guide

Common issues and solutions for Symphony token launch.

---

## Pre-Launch Issues

### "npm install" fails

**Symptom:** Errors during `npm install`

**Solutions:**
```bash
# Clear npm cache
npm cache clean --force

# Try with bun instead
brew install oven-sh/bun/bun
bun install

# Check Node version (need 18+)
node --version
```

### Logo generation fails

**Symptom:** `generate-logo.sh` errors or no output

**Solutions:**
1. Check MCP is configured:
   ```bash
   claude mcp list
   ```

2. Use manual generation:
   - Visit https://aistudio.google.com
   - Use prompt from `prompts/logo.txt`
   - Save as `assets/logos/symphony-logo-512.png`

3. Use fallback emoji logo:
   - See `FALLBACK_LOGO.md`
   - 🎭 on black background
   - 2 minutes to create

### Scripts not executable

**Symptom:** "Permission denied" when running scripts

**Solution:**
```bash
chmod +x scripts/*.sh scripts/*.js
```

---

## Deployment Issues

### Phantom wallet not connecting

**Symptom:** Browser automation can't connect wallet

**Causes:**
- Wallet locked
- Browser extension not installed
- Wrong browser profile

**Solutions:**
1. Unlock Phantom manually
2. Visit pump.fun manually first
3. Connect wallet once by hand
4. Then re-run script

### "Insufficient SOL balance"

**Symptom:** Transaction fails due to low balance

**Solution:**
```bash
# Check balance in Phantom
# Need 10+ SOL:
# - 5 SOL for initial buy
# - 5 SOL buffer for gas + testing
```

Buy SOL:
- Coinbase/Binance → Send to Phantom
- Or use on-ramp in Phantom app

### Browser automation hangs

**Symptom:** Script stuck waiting for element

**Solutions:**
1. Check pump.fun is up:
   ```bash
   curl -I https://pump.fun
   ```

2. Run with visible browser:
   ```bash
   HEADLESS=false npm run deploy-token
   ```

3. Manually intervene:
   - Browser opens
   - Fill form by hand
   - Script continues

### Token deployment fails

**Symptom:** Error during token creation

**Possible causes:**
- Network congestion
- pump.fun API issues
- Wrong input format

**Solutions:**
1. Check error screenshot:
   ```bash
   ls -la error-screenshot.png
   ```

2. Try manual deployment:
   - Go to pump.fun
   - Upload logo manually
   - Fill form with description from `prompts/description.txt`
   - Deploy

3. Wait and retry:
   ```bash
   # Script is idempotent
   npm run deploy-token
   ```

---

## Post-Deployment Issues

### Token address not saved

**Symptom:** `.token-address` file missing

**Solution:**
```bash
# Find token on pump.fun
# Copy address manually
echo "YOUR_TOKEN_ADDRESS" > .token-address
```

### Landing page not updating

**Symptom:** GitHub Pages shows old version

**Causes:**
- Git push failed
- Pages not enabled
- Build delay

**Solutions:**
1. Check git status:
   ```bash
   git status
   git log -1
   ```

2. Manual deploy:
   ```bash
   # Edit index.html manually
   sed -i '' 's/REPLACE_WITH_TOKEN_ADDRESS/YOUR_ADDRESS/g' index.html
   
   git add index.html
   git commit -m "Update token address"
   git push
   ```

3. Enable GitHub Pages:
   - Repo Settings → Pages
   - Source: main branch
   - Save

4. Wait 2-3 minutes:
   - Pages can take time to build
   - Clear browser cache

### Tweets not formatting

**Symptom:** `post-tweets.js` errors or bad output

**Solutions:**
1. Check token address exists:
   ```bash
   cat .token-address
   ```

2. Manual formatting:
   - Open `prompts/tweet-thread.txt`
   - Replace `{PUMP_FUN_LINK}` with your link
   - Replace `{TOKEN_ADDRESS}` with your address
   - Copy-paste to Twitter

3. Check character counts:
   ```bash
   npm run post-tweets
   # Output shows char count per tweet
   ```

### Twitter API issues

**Symptom:** Auto-posting fails

**Solution:**
- Twitter API is optional
- Use manual posting:
  ```bash
  cat twitter-thread-formatted.txt
  # Copy each tweet to Twitter
  ```

---

## Monitoring Issues

### Monitor script crashes

**Symptom:** `monitor.js` exits or errors

**Causes:**
- pump.fun API down
- Invalid token address
- Network issues

**Solutions:**
1. Check token address:
   ```bash
   cat .token-address
   # Should be valid Solana address
   ```

2. Test API manually:
   ```bash
   curl "https://pump.fun/api/tokens/$(cat .token-address)"
   ```

3. Restart monitor:
   ```bash
   npm run monitor
   ```

4. Check for errors:
   ```bash
   # Run in debug mode
   NODE_ENV=development npm run monitor
   ```

### Price/holders showing zero

**Symptom:** Monitor shows 0 for all metrics

**Causes:**
- Token not on pump.fun yet
- API delay
- Wrong address

**Solutions:**
1. Wait 1-2 minutes after deploy
2. Verify on pump.fun manually
3. Check address is correct

---

## Common Errors

### "Cannot find module 'playwright'"

**Solution:**
```bash
npm install playwright
npx playwright install
```

### "EACCES: permission denied"

**Solution:**
```bash
chmod +x scripts/*.sh
# Or run with bash explicitly:
bash scripts/autonomous-launch.sh
```

### "Git push rejected"

**Solution:**
```bash
# Pull first
git pull origin main

# Then push
git push
```

### "Wallet approval timeout"

**Cause:** Took too long to approve in Phantom

**Solution:**
- Script waits 120 seconds
- Approve faster next time
- Or re-run script (it's safe)

---

## Emergency Procedures

### Complete reset

**If everything is broken:**

```bash
# 1. Stop all processes
pkill -f "node"

# 2. Clean state
rm -f .token-address
rm -f error-screenshot.png

# 3. Reinstall dependencies
rm -rf node_modules
npm install

# 4. Try again
npm run pre-flight
npm run autonomous-launch
```

### Manual launch (if automation fails)

**Step-by-step manual process:**

1. **Logo:**
   - Use 🎭 emoji on black background
   - Or generate at https://aistudio.google.com

2. **Token:**
   - Go to https://pump.fun
   - Connect Phantom
   - Click "Create Token"
   - Fill form:
     - Name: Symphony
     - Symbol: SYMPHONY
     - Description: (from `prompts/description.txt`)
     - Image: Upload logo
   - Create & approve
   - Buy 5 SOL worth
   - Save token address

3. **Tweets:**
   - Open `prompts/tweet-thread.txt`
   - Replace `{PUMP_FUN_LINK}` with your token link
   - Post to Twitter manually

4. **Landing page:**
   - Edit `index.html`
   - Replace `REPLACE_WITH_TOKEN_ADDRESS`
   - Git commit & push

5. **Monitor:**
   - Watch pump.fun page manually
   - Or fix and run `npm run monitor`

---

## Getting Help

### Debug mode

**Enable verbose logging:**

```bash
# For deploy script
DEBUG=1 npm run deploy-token

# For monitoring
NODE_ENV=development npm run monitor
```

### Log files

**Check these for errors:**

```bash
# Script output
ls -la *.log

# Error screenshots
ls -la error-screenshot*.png

# Git status
git status
git log -1
```

### Documentation

**Read these in order:**

1. `SETUP.md` - Installation
2. `docs/LAUNCH_CHECKLIST.md` - Step-by-step
3. `docs/ARCHITECTURE.md` - How it works
4. This file - Troubleshooting

### Community

**If stuck:**

- Check GitHub issues: https://github.com/ckorhonen/symphony-pump/issues
- Review documentation in `docs/`
- Manual fallback is always available

---

## Prevention Tips

**Avoid issues by:**

1. **Test before launch:**
   ```bash
   npm run pre-flight
   ```

2. **Use staging:**
   - Test on Solana devnet first
   - Verify all steps manually

3. **Check prerequisites:**
   - 10+ SOL in wallet
   - All dependencies installed
   - Scripts executable

4. **Have fallbacks ready:**
   - Emoji logo prepared
   - Manual steps documented
   - Twitter thread formatted

5. **Don't panic:**
   - Most issues are fixable
   - Manual fallback exists
   - Community is understanding

---

## Known Issues

### ImageMagick not installed

**Impact:** Logo resizing unavailable

**Fix:**
```bash
brew install imagemagick
```

**Workaround:** Use online resizer or manual sizes

### Twitter API rate limits

**Impact:** Can't auto-post thread

**Workaround:** Post manually (preferred anyway)

### GitHub Pages delay

**Impact:** Landing page takes 2-3 min to update

**Workaround:** Wait patiently, clear browser cache

### pump.fun API changes

**Impact:** Automation may break if UI changes

**Workaround:** Manual deployment always works

---

## Still Stuck?

**Last resort checklist:**

- [ ] Tried manual approach?
- [ ] Checked all error messages?
- [ ] Read relevant docs?
- [ ] Tested prerequisites?
- [ ] Used fallback options?

**If all else fails:**
- Document the issue
- Use manual fallback
- Launch anyway (can fix later)
- Token doesn't need perfection

---

**Remember:** The system is designed with fallbacks. If automation breaks, go manual. The launch can still succeed. 🎭

**Last updated:** 2026-03-08 19:20 EST
