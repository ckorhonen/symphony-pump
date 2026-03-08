#!/usr/bin/env node
/**
 * Post Launch Thread to Twitter
 * 
 * Supports two methods:
 * 1. Twitter API (if credentials provided)
 * 2. Manual posting (generates formatted text)
 */

import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import 'dotenv/config'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const projectRoot = join(__dirname, '..')

// Load token address
const getTokenAddress = () => {
  try {
    return readFileSync(join(projectRoot, '.token-address'), 'utf-8').trim()
  } catch (error) {
    console.error('❌ Token address not found. Run: npm run deploy-token')
    process.exit(1)
  }
}

// Load tweet template
const getTweetThread = (tokenAddress) => {
  const template = readFileSync(join(projectRoot, 'prompts/tweet-thread.txt'), 'utf-8')
  
  return template
    .replace(/{PUMP_FUN_LINK}/g, `https://pump.fun/${tokenAddress}`)
    .replace(/{TOKEN_ADDRESS}/g, tokenAddress)
    .replace(/{WEBSITE_URL}/g, 'https://ckorhonen.github.io/symphony-pump')
}

// Parse thread into individual tweets
const parseThread = (threadText) => {
  return threadText
    .split(/\n---\n/)
    .map(tweet => tweet.trim())
    .filter(tweet => tweet.length > 0)
    .map((tweet, index) => ({
      number: index + 1,
      text: tweet.replace(/^TWEET \d+ \(.*?\):\n/, ''),
      isMain: index === 0
    }))
}

async function postTweets() {
  console.log('🐦 Launch Thread Poster')
  console.log('━'.repeat(50))
  console.log('')

  const tokenAddress = getTokenAddress()
  const threadText = getTweetThread(tokenAddress)
  const tweets = parseThread(threadText)

  console.log(`📋 Thread ready: ${tweets.length} tweets`)
  console.log('')

  // Check if Twitter API credentials are available
  const hasTwitterAPI = !!(
    process.env.TWITTER_API_KEY &&
    process.env.TWITTER_API_SECRET &&
    process.env.TWITTER_ACCESS_TOKEN &&
    process.env.TWITTER_ACCESS_SECRET
  )

  if (hasTwitterAPI) {
    console.log('✅ Twitter API credentials found')
    console.log('🚀 Posting thread automatically...')
    console.log('')
    
    // TODO: Implement Twitter API posting
    // For now, fall through to manual mode
    console.log('⚠️  Automatic posting not implemented yet')
    console.log('   Falling back to manual mode...')
    console.log('')
  }

  // Manual mode: Display tweets for copy-paste
  console.log('📝 Manual Posting Mode')
  console.log('')
  console.log('Copy and paste these tweets to Twitter:')
  console.log('')
  console.log('━'.repeat(50))
  
  tweets.forEach(({ number, text, isMain }) => {
    console.log('')
    console.log(`TWEET ${number}${isMain ? ' (PIN THIS)' : ''}:`)
    console.log('─'.repeat(50))
    console.log(text)
    console.log('─'.repeat(50))
    
    if (isMain) {
      console.log('👆 Post this first and PIN to your profile')
    } else {
      console.log(`👆 Post as reply to tweet ${number - 1}`)
    }
    
    console.log('')
    
    // Character count
    const charCount = text.length
    if (charCount > 280) {
      console.log(`⚠️  WARNING: ${charCount} chars (over 280 limit!)`)
    } else {
      console.log(`✅ ${charCount} chars`)
    }
    
    console.log('')
  })

  console.log('━'.repeat(50))
  console.log('')
  console.log('📊 Thread Statistics:')
  console.log(`   Total tweets: ${tweets.length}`)
  console.log(`   Total characters: ${tweets.reduce((sum, t) => sum + t.text.length, 0)}`)
  console.log(`   Avg per tweet: ${Math.round(tweets.reduce((sum, t) => sum + t.text.length, 0) / tweets.length)}`)
  console.log('')
  console.log('🎯 Next Steps:')
  console.log('   1. Post tweet 1 (main thread starter)')
  console.log('   2. PIN tweet 1 to your profile')
  console.log('   3. Post tweets 2-6 as replies')
  console.log('   4. Run: npm run deploy-page')
  console.log('')
  console.log('━'.repeat(50))
  
  // Save formatted thread to file
  const outputPath = join(projectRoot, 'twitter-thread-formatted.txt')
  const formattedThread = tweets
    .map(({ number, text, isMain }) =>
      `TWEET ${number}${isMain ? ' (PIN THIS)' : ''}:\n${text}\n`
    )
    .join('\n━'.repeat(50) + '\n\n')
  
  writeFileSync(outputPath, formattedThread)
  console.log(`💾 Thread saved to: twitter-thread-formatted.txt`)
  console.log('')
}

// Helper to write file
import { writeFileSync } from 'fs'

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  postTweets()
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

export { postTweets, getTweetThread }
