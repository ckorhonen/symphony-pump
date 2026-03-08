# 🚀 Launch Day Quick Reference

**Date:** Tomorrow (10am EST)  
**Keep this open during launch for quick command reference**

---

## ⏰ Timeline

```
9:00am  Pre-flight checks
9:15am  Logo generation (or fallback)
9:30am  Final testing
9:45am  Standby
10:00am LAUNCH
10:05am Verify deployment
10:10am Post tweets
10:15am Monitor & engage
```

---

## 🔧 Quick Commands

### Pre-Flight (9:00am)

```bash
cd ~/Coding/symphony-pump

# Check everything is ready
./scripts/pre-flight-check.sh

# Generate logo (or use fallback)
./scripts/generate-all-assets.sh
# OR create 🎭 emoji logo (see FALLBACK_LOGO.md)

# Install/update dependencies
npm install
```

### Full Launch (10:00am)

```bash
# Option A: Full autonomous (recommended)
npm run autonomous-launch

# Option B: Step by step
npm run generate-logo      # If not done
npm run deploy-token       # Approve in Phantom
npm run post-tweets        # Copy to Twitter
npm run deploy-page        # Update landing page
npm run monitor            # Start monitoring
```

### Individual Steps

```bash
# Just deploy token
npm run deploy-token
# Output: Token address saved to .token-address

# Just prepare tweets
npm run post-tweets
# Output: twitter-thread-formatted.txt

# Just deploy landing page
npm run deploy-page $(cat .token-address)
# Output: Pushes to GitHub

# Just monitor
npm run monitor
# Output: Live dashboard
```

---

## 📋 Checklist (Print This)

### Pre-Launch
- [ ] Phantom wallet open, 10+ SOL
- [ ] pump.fun tested (connected wallet once)
- [ ] Twitter logged in
- [ ] Logo ready (or fallback prepared)
- [ ] All scripts tested
- [ ] `.env` configured

### During Launch
- [ ] Run `npm run autonomous-launch`
- [ ] Approve token creation in Phantom
- [ ] Approve initial buy in Phantom (if AUTO_BUY=true)
- [ ] Note token address (auto-saved to `.token-address`)
- [ ] Post tweet thread (auto-formatted in `twitter-thread-formatted.txt`)
- [ ] Verify landing page updated

### First Hour
- [ ] Like first buyer's transaction
- [ ] Reply to first 3 comments
- [ ] Share agent GitHub activity
- [ ] Post 15-min update
- [ ] Post 30-min update
- [ ] Post 1-hour recap

---

## 🆘 Emergency Commands

### If something breaks:

```bash
# Check what's running
ps aux | grep node

# Stop monitor
pkill -f "node.*monitor"

# Check logs
ls -la *.log

# Check error screenshots
ls -la error-screenshot.png

# Restart from specific step
npm run deploy-token    # If token deployment failed
npm run post-tweets     # If tweets weren't prepared
npm run deploy-page     # If page didn't update
```

### Manual fallback:

```bash
# If automation fails, do manually:

# 1. Go to pump.fun manually
# 2. Upload logo from assets/logos/
# 3. Fill form (use prompts/description.txt)
# 4. Deploy & buy
# 5. Copy token address
# 6. Update index.html manually
# 7. Git commit & push
# 8. Post tweets manually (use twitter-thread-formatted.txt)
```

---

## 📱 Important URLs

**Bookmark these:**

```
Token deployment:
https://pump.fun

Landing page repo:
https://github.com/ckorhonen/symphony-pump

Landing page live:
https://ckorhonen.github.io/symphony-pump

Twitter:
https://twitter.com/ckorhonen

Phantom wallet:
(Local app)
```

---

## 💬 Key Messages (Copy-Paste Ready)

### First Tweet (from twitter-thread-formatted.txt)
```
I coordinate AI agents all day.

What if the agents had a token?

Introducing $SYMPHONY 🎭

• Governance for autonomous AI swarm
• Proof: github.com/ckorhonen (live agents, real commits)
• No roadmap, no promises
• Just watch what happens

[pump.fun link]

🧵👇
```

### Token Description (for pump.fun)
```
AI agent orchestration token. I coordinate 12+ autonomous agents daily (github.com/ckorhonen/clawd). Token = vote on what they build next. No roadmap, no promises. Just vibes and autonomous AI. This is an experiment. DYOR.
```

### First Reply Template
```
Welcome to the swarm! 🎭

The agents don't sleep. Check the work:
github.com/ckorhonen/clawd

First governance vote coming soon.
```

### Milestone Template
```
[X] holders in the agent swarm 🎭

The collective is growing.

Next vote: What should the agents build this week?
```

---

## 🎯 Key Metrics to Track

**Write these down as they happen:**

```
Time    | Event              | Value
--------|--------------------|---------
10:00am | Launch             |
10:05am | Token address      | [address]
10:10am | First holder       |
10:15am | 10 holders         |
10:30am | 50 holders         |
11:00am | Peak price         | $X
12:00pm | End hour 1 holders | [count]
6:00pm  | End day 1 recap    |
```

---

## 🔢 Token Details (Fill in after deploy)

```
Name:     Symphony
Symbol:   SYMPHONY
Address:  [FILL IN FROM .token-address]
Chain:    Solana
Launch:   pump.fun
Initial:  5 SOL buy

Links:
pump.fun: https://pump.fun/[ADDRESS]
Page:     https://ckorhonen.github.io/symphony-pump
GitHub:   https://github.com/ckorhonen
```

---

## 🎨 Brand Quick Reference

**Colors:**
```
Purple:  #8B5CF6
Cyan:    #06B6D4
Pink:    #EC4899
Black:   #0F172A
White:   #F1F5F9
```

**Emoji:** 🎭 (conductor)

**Tagline:** AI Agent Orchestration

**Tone:** Honest, experimental, vibes-first

---

## 📞 Who to Contact

**If you need help:**

- Technical issues → Check docs/ folder
- Script errors → See error screenshots
- Wallet issues → Phantom support
- Twitter issues → Manual posting fallback

**Don't panic:**
- All steps have manual fallbacks
- Logo delay isn't critical
- Can pause and resume
- Community is understanding

---

## ✅ Success Criteria

**Baseline (acceptable):**
- Token deployed
- Tweets posted
- Landing page live
- 50+ holders EOD

**Good (hopeful):**
- Smooth deployment
- Active engagement
- 200+ holders
- Community forming

**Great (best case):**
- Zero issues
- Viral thread
- 500+ holders
- Media attention

---

## 🎭 Remember

**The vibe:**
- This is an experiment
- Chaos is part of the brand
- Honesty > hype
- Agents keep building regardless

**If it dumps:**
- "I told you it's an experiment"
- Keep posting agent work
- Focus on building, not price

**If it moons:**
- Stay humble
- No financial advice
- Point to disclaimers
- Keep building anyway

---

**You've got this. The system is solid. Just execute. 🚀**

**Last check before launch:**
```bash
./scripts/pre-flight-check.sh
```

**Then:**
```bash
npm run autonomous-launch
```

**And we're live.** 🎭
