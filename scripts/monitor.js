#!/usr/bin/env node
/**
 * Token Monitor & Auto-Engagement
 * 
 * Monitors token price, holders, volume
 * Posts milestone tweets
 * Tracks sentiment
 */

import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import 'dotenv/config'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const projectRoot = join(__dirname, '..')

// Configuration
const CHECK_INTERVAL_MS = 60000  // 1 minute
const MILESTONE_HOLDERS = [50, 100, 250, 500, 1000, 2500, 5000]
const MILESTONE_VOLUME = [1000, 5000, 10000, 50000, 100000]  // USD

// Track state
let lastState = {
  holders: 0,
  price: 0,
  volume: 0,
  marketCap: 0
}

let milestonesMet = {
  holders: [],
  volume: []
}

// Load token address
const getTokenAddress = () => {
  try {
    return readFileSync(join(projectRoot, '.token-address'), 'utf-8').trim()
  } catch (error) {
    console.error('❌ Token address not found. Run: npm run deploy-token')
    process.exit(1)
  }
}

// Fetch token data from pump.fun API
async function fetchTokenData(tokenAddress) {
  try {
    const response = await fetch(`https://pump.fun/api/tokens/${tokenAddress}`)
    
    if (!response.ok) {
      throw new Error(`API error: ${response.status}`)
    }
    
    const data = await response.json()
    
    return {
      price: parseFloat(data.price || 0),
      holders: parseInt(data.holders || 0),
      volume: parseFloat(data.volume_24h || 0),
      marketCap: parseFloat(data.market_cap || 0),
      priceChange24h: parseFloat(data.price_change_24h || 0)
    }
  } catch (error) {
    console.error('Error fetching token data:', error.message)
    return null
  }
}

// Check for milestones and post updates
function checkMilestones(currentState) {
  const updates = []
  
  // Holder milestones
  for (const milestone of MILESTONE_HOLDERS) {
    if (
      currentState.holders >= milestone &&
      lastState.holders < milestone &&
      !milestonesMet.holders.includes(milestone)
    ) {
      updates.push({
        type: 'holders',
        milestone,
        message: `🎭 ${milestone} holders now part of the agent swarm. LFG.`
      })
      milestonesMet.holders.push(milestone)
    }
  }
  
  // Volume milestones
  for (const milestone of MILESTONE_VOLUME) {
    if (
      currentState.volume >= milestone &&
      lastState.volume < milestone &&
      !milestonesMet.volume.includes(milestone)
    ) {
      updates.push({
        type: 'volume',
        milestone,
        message: `💰 24h volume just crossed $${(milestone / 1000).toFixed(0)}k. The agents are pleased.`
      })
      milestonesMet.volume.push(milestone)
    }
  }
  
  return updates
}

// Display current status
function displayStatus(tokenAddress, data) {
  console.clear()
  console.log('🌀 SYMPHONY Monitor')
  console.log('━'.repeat(60))
  console.log('')
  console.log(`Token: ${tokenAddress}`)
  console.log(`Time:  ${new Date().toLocaleString()}`)
  console.log('')
  console.log('━'.repeat(60))
  console.log('')
  console.log('📊 Current Metrics:')
  console.log(`   Price:       $${data.price.toFixed(6)}`)
  console.log(`   Market Cap:  $${data.marketCap.toLocaleString()}`)
  console.log(`   Holders:     ${data.holders}`)
  console.log(`   24h Volume:  $${data.volume.toLocaleString()}`)
  console.log(`   24h Change:  ${data.priceChange24h >= 0 ? '+' : ''}${data.priceChange24h.toFixed(2)}%`)
  console.log('')
  console.log('🎯 Next Milestones:')
  
  // Next holder milestone
  const nextHolderMilestone = MILESTONE_HOLDERS.find(m => m > data.holders)
  if (nextHolderMilestone) {
    const remaining = nextHolderMilestone - data.holders
    console.log(`   Holders: ${nextHolderMilestone} (${remaining} to go)`)
  }
  
  // Next volume milestone
  const nextVolumeMilestone = MILESTONE_VOLUME.find(m => m > data.volume)
  if (nextVolumeMilestone) {
    const remaining = nextVolumeMilestone - data.volume
    console.log(`   Volume:  $${nextVolumeMilestone.toLocaleString()} ($${remaining.toLocaleString()} to go)`)
  }
  
  console.log('')
  console.log('━'.repeat(60))
  console.log('')
  console.log('🔔 Milestone Alerts:')
  if (milestonesMet.holders.length === 0 && milestonesMet.volume.length === 0) {
    console.log('   None yet...')
  } else {
    milestonesMet.holders.forEach(m => {
      console.log(`   ✅ ${m} holders reached`)
    })
    milestonesMet.volume.forEach(m => {
      console.log(`   ✅ $${m.toLocaleString()} volume reached`)
    })
  }
  
  console.log('')
  console.log('━'.repeat(60))
  console.log(`Next check in ${CHECK_INTERVAL_MS / 1000}s... (Ctrl+C to stop)`)
}

// Post milestone tweet (manual for now)
function postMilestone(update) {
  console.log('')
  console.log('🎉 MILESTONE REACHED!')
  console.log(`   Type: ${update.type}`)
  console.log(`   Milestone: ${update.milestone}`)
  console.log('')
  console.log('📝 Suggested tweet:')
  console.log('   ' + update.message)
  console.log('')
  
  // TODO: Auto-post via Twitter API
  // For now, log for manual posting
}

// Main monitoring loop
async function monitor() {
  const tokenAddress = getTokenAddress()
  
  console.log('🌀 Starting Symphony Monitor')
  console.log('━'.repeat(60))
  console.log(`Token: ${tokenAddress}`)
  console.log(`Check interval: ${CHECK_INTERVAL_MS / 1000}s`)
  console.log('')
  console.log('Press Ctrl+C to stop')
  console.log('')
  
  // Initial fetch
  const initialData = await fetchTokenData(tokenAddress)
  if (initialData) {
    lastState = initialData
    displayStatus(tokenAddress, initialData)
  }
  
  // Start monitoring loop
  setInterval(async () => {
    const data = await fetchTokenData(tokenAddress)
    
    if (!data) return
    
    // Check for milestones
    const updates = checkMilestones(data)
    
    // Post milestone updates
    for (const update of updates) {
      postMilestone(update)
    }
    
    // Update display
    displayStatus(tokenAddress, data)
    
    // Update last state
    lastState = data
    
  }, CHECK_INTERVAL_MS)
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  monitor()
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

export { monitor, fetchTokenData }
