# ✅ Symphony Launch Checklist

Everything you need to launch, in order.

---

## Pre-Launch (Day Before)

### 1. Environment Setup

**Install dependencies:**
```bash
cd symphony-pump
npm install
```

**Configure environment:**
```bash
cp .env.example .env
# Edit .env with your settings
```

**Verify tools:**
```bash
node --version  # Should be 18+
npm --version
git --version
```

### 2. Wallet Preparation

- [ ] Phantom wallet installed
- [ ] Wallet funded with 10 SOL minimum
- [ ] Test transaction completed
- [ ] Visited pump.fun and connected wallet once
- [ ] Wallet is a **burner** (not main stack!)

### 3. Assets Ready

- [ ] Logo generated (or prompt ready)
  ```bash
  npm run generate-logo
  # Or use prompt from prompts/logo.txt
  ```
- [ ] Description reviewed (prompts/description.txt)
- [ ] Tweet thread reviewed (prompts/tweet-thread.txt)
- [ ] Landing page checked (index.html)

### 4. Accounts Ready

- [ ] Twitter account logged in
- [ ] GitHub account with repo access
- [ ] Discord/Telegram (optional, for community)

---

## Launch Day (10am EST)

### Phase 1: Pre-Flight (15 min before)

**9:45am:**
- [ ] Open Phantom wallet
- [ ] Check SOL balance (10+ SOL)
- [ ] Visit pump.fun (confirm it's up)
- [ ] Terminal ready in `symphony-pump/` directory

**Final check:**
```bash
# Verify everything is ready
ls assets/logos/symphony-logo-512.png  # Logo exists
cat .env  # Config looks good
git status  # Repo clean
```

### Phase 2: Launch (10:00am)

**Option A: Full Autonomous**
```bash
npm run autonomous-launch
```

**Option B: Step by Step**
```bash
# Step 1: Generate logo (if not done)
npm run generate-logo

# Step 2: Deploy token
npm run deploy-token
# Approve transaction in Phantom when prompted

# Step 3: Prepare tweets
npm run post-tweets
# Copy output to Twitter

# Step 4: Deploy landing page
npm run deploy-page $(cat .token-address)

# Step 5: Start monitoring
npm run monitor
```

### Phase 3: Immediate Post-Launch (First 5 min)

**As soon as token deploys:**

1. **Save token address**
   ```bash
   cat .token-address  # Copy this
   ```

2. **Post tweet thread** (if not automated)
   - Copy from `twitter-thread-formatted.txt`
   - Post tweet 1 → Pin to profile
   - Post tweets 2-6 as replies

3. **Verify landing page**
   - Visit https://ckorhonen.github.io/symphony-pump
   - Confirm token address appears
   - Test pump.fun link works

4. **Initial engagement**
   - Like first buyer's transaction
   - Reply to first 3 comments
   - Set the tone: casual, honest, vibes

### Phase 4: First Hour (10:00am-11:00am)

**Every 10 minutes:**
- [ ] Check monitor for holder count
- [ ] Reply to all mentions
- [ ] Retweet interesting holder content
- [ ] Screenshot milestones

**Post updates:**
- 10:15am: "15 holders in first 15 minutes 🎭"
- 10:30am: "The swarm is active. Check the agent logs: [github link]"
- 10:45am: "First governance vote coming soon. Stay tuned."

### Phase 5: First Day (11:00am-6:00pm)

**Hourly posts:**
- Share agent activity from GitHub
- Post holder milestones (50, 100, 250...)
- Respond to all comments
- No price talk, just vibes

**By end of day:**
- [ ] Day 1 recap thread posted
- [ ] First governance poll drafted
- [ ] Monitor still running
- [ ] All mentions replied to

---

## Post-Launch Checklist

### Day 2
- [ ] Morning update: "X holders, $Y volume, agents still building"
- [ ] First governance poll: "What should the swarm tackle this week?"
- [ ] Agent activity screenshot
- [ ] Engage with community

### Week 1
- [ ] Daily updates (2-3 posts/day)
- [ ] Share GitHub commits
- [ ] Execute first community vote
- [ ] Build Discord/Telegram (if traction)

### Month 1
- [ ] Weekly governance votes
- [ ] Monthly treasury report
- [ ] Retrospective thread
- [ ] Plan evolution features

---

## Emergency Contacts

**If something breaks:**

1. **Check error logs**
   ```bash
   tail -f ~/symphony-pump/*.log
   ```

2. **Screenshot errors**
   - Save to `error-screenshot.png`
   - Share in GitHub issue

3. **Manual fallback**
   - All steps can be done manually
   - See docs/ for guides

4. **Kill switch**
   ```bash
   # Stop monitor
   pkill -f "node.*monitor"
   
   # Pause operations
   # Just don't post until resolved
   ```

---

## Rollback Procedures

### If token deploy fails:
1. Check Phantom for failed transaction
2. Verify SOL balance
3. Try again (script is idempotent)

### If tweets don't post:
1. Use `twitter-thread-formatted.txt`
2. Post manually
3. Continue with other steps

### If landing page doesn't update:
1. Manually edit `index.html`
2. Git commit & push
3. Wait 2-3 min for GitHub Pages

### If monitor crashes:
1. Check token address is saved
2. Restart: `npm run monitor`
3. Continue manually if needed

---

## Success Metrics

**Baseline (acceptable):**
- 50+ holders by EOD
- $50k+ peak market cap
- 30+ tweets/mentions
- Community forming

**Good (hopeful):**
- 200+ holders by EOD
- $200k+ peak market cap
- 100+ tweets/mentions
- Active Discord/Telegram

**Moon (unlikely but awesome):**
- 500+ holders by EOD
- $1M+ peak market cap
- Viral on crypto Twitter
- Media coverage

---

## Common Mistakes to Avoid

❌ **Don't:**
- Rush the wallet approvals
- Post price predictions
- Engage with FUD in first 6 hours
- Panic if it dumps
- Stop agent work if token dies

✅ **Do:**
- Take your time with transactions
- Focus on vibes & agent work
- Reply to all positive mentions
- Stay calm if price drops
- Keep building regardless

---

## Final Pre-Flight Check

**Right before launch, verify:**

```bash
# 1. Logo exists
ls assets/logos/symphony-logo-512.png

# 2. Config is set
cat .env | grep -v "^#" | grep "="

# 3. Wallet has SOL
# (Check Phantom manually)

# 4. Scripts are executable
ls -la scripts/*.sh scripts/*.js

# 5. Git is clean
git status

# 6. Repo is pushed
git log -1
```

**If all checks pass:**

```bash
echo "Ready to launch! 🚀"
```

**If any fail:**
- Fix before proceeding
- See SETUP.md for help

---

## Post-Launch Notes

**Record for posterity:**

```bash
# Save launch timestamp
date > .launch-timestamp

# Save initial metrics
echo "Holders: [count]" >> .launch-notes
echo "Price: $[amount]" >> .launch-notes
echo "Vibes: [status]" >> .launch-notes
```

---

## Questions During Launch?

**Check these first:**
1. [SETUP.md](../SETUP.md) - Setup issues
2. [docs/TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Common problems
3. [BUILD_LOG.md](../BUILD_LOG.md) - Build status

**Still stuck?**
- Pause and debug
- Manual fallback available for all steps
- Document the issue for later

---

**Ready? See you at launch. 🎭**

**Last updated:** 2026-03-08 19:00 EST
