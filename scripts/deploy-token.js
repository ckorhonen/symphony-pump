#!/usr/bin/env node
/**
 * Autonomous Token Deployment on pump.fun
 * 
 * This script automates the token creation process using browser automation.
 * Requires: Phantom wallet pre-connected to pump.fun
 */

import { chromium } from 'playwright'
import { readFileSync, writeFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import 'dotenv/config'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const projectRoot = join(__dirname, '..')

// Configuration
const PUMP_FUN_URL = 'https://pump.fun'
const HEADLESS = process.env.HEADLESS !== 'false'  // Set to false for debugging
const INITIAL_BUY_SOL = process.env.INITIAL_BUY_SOL || '5'

// Load assets and prompts
const LOGO_PATH = join(projectRoot, 'assets/logos/symphony-logo-512.png')
const DESCRIPTION = readFileSync(join(projectRoot, 'prompts/description.txt'), 'utf-8').trim()

async function deployToken() {
  console.log('🚀 Autonomous Token Deployment')
  console.log('━'.repeat(50))
  console.log('')

  // Check prerequisites
  console.log('📋 Pre-flight checks...')
  
  try {
    // Check if logo exists
    readFileSync(LOGO_PATH)
    console.log('✅ Logo found')
  } catch (error) {
    console.error('❌ Logo not found. Run: npm run generate-logo')
    process.exit(1)
  }

  // Launch browser
  console.log('')
  console.log('🌐 Launching browser...')
  const browser = await chromium.launch({
    headless: HEADLESS,
    slowMo: 100  // Slow down for stability
  })
  
  const context = await browser.newContext({
    // Use existing Phantom wallet session if available
    viewport: { width: 1280, height: 720 }
  })
  
  const page = await context.newPage()
  
  try {
    // Navigate to pump.fun
    console.log('📍 Navigating to pump.fun...')
    await page.goto(PUMP_FUN_URL, { waitUntil: 'networkidle' })
    
    // Wait for page load
    await page.waitForTimeout(2000)
    
    // Check if wallet is connected
    console.log('🔗 Checking wallet connection...')
    const walletButton = page.locator('button:has-text("Connect")')
    
    if (await walletButton.count() > 0) {
      console.log('⚠️  Wallet not connected')
      console.log('   Please connect Phantom wallet manually')
      console.log('   Press Enter when ready...')
      
      // Wait for manual connection
      process.stdin.once('data', async () => {
        console.log('   Continuing...')
      })
      
      // In headless mode, can't wait for user input
      if (HEADLESS) {
        throw new Error('Wallet not connected. Run in non-headless mode first.')
      }
    } else {
      console.log('✅ Wallet connected')
    }
    
    // Click "Create Token" button
    console.log('')
    console.log('📝 Starting token creation...')
    await page.click('text=Create Token')
    await page.waitForTimeout(1000)
    
    // Fill in token details
    console.log('   Name: Symphony')
    await page.fill('input[name="name"]', 'Symphony')
    
    console.log('   Symbol: SYMPHONY')
    await page.fill('input[name="symbol"]', 'SYMPHONY')
    
    console.log('   Description: [from prompts/description.txt]')
    await page.fill('textarea[name="description"]', DESCRIPTION)
    
    // Upload logo
    console.log('   Logo: Uploading...')
    await page.setInputFiles('input[type="file"]', LOGO_PATH)
    await page.waitForTimeout(2000)
    console.log('   ✅ Logo uploaded')
    
    // Review before deployment
    console.log('')
    console.log('━'.repeat(50))
    console.log('📋 Token Details:')
    console.log('   Name: Symphony')
    console.log('   Symbol: SYMPHONY')
    console.log(`   Description: ${DESCRIPTION.slice(0, 100)}...`)
    console.log('   Logo: symphony-logo-512.png')
    console.log('━'.repeat(50))
    console.log('')
    
    // Deploy token
    console.log('🚀 Deploying token...')
    console.log('   (This will trigger Phantom wallet approval)')
    
    await page.click('button:has-text("Create")')
    
    // Wait for transaction approval
    console.log('⏳ Waiting for transaction approval in Phantom...')
    console.log('   Please approve the transaction in your wallet')
    
    // Wait for success page or token address
    await page.waitForSelector('.token-address, text=Success', { timeout: 120000 })
    
    console.log('✅ Token deployed!')
    
    // Extract token address
    const tokenAddressElement = page.locator('.token-address').first()
    const tokenAddress = await tokenAddressElement.textContent()
    
    console.log('')
    console.log('━'.repeat(50))
    console.log('🎉 TOKEN DEPLOYED')
    console.log(`   Address: ${tokenAddress}`)
    console.log('━'.repeat(50))
    
    // Save token address
    writeFileSync(join(projectRoot, '.token-address'), tokenAddress.trim())
    writeFileSync(
      join(projectRoot, '.env.local'),
      `TOKEN_ADDRESS=${tokenAddress.trim()}\n`,
      { flag: 'a' }
    )
    
    console.log('✅ Token address saved to .token-address')
    
    // Optional: Execute initial buy
    if (process.env.AUTO_BUY === 'true') {
      console.log('')
      console.log(`💰 Executing initial buy (${INITIAL_BUY_SOL} SOL)...`)
      
      await page.fill('input[name="amount"]', INITIAL_BUY_SOL)
      await page.click('button:has-text("Buy")')
      
      console.log('⏳ Waiting for buy transaction approval...')
      await page.waitForSelector('text=Success', { timeout: 120000 })
      
      console.log('✅ Initial buy complete!')
    } else {
      console.log('')
      console.log('ℹ️  Skipping initial buy (set AUTO_BUY=true to enable)')
      console.log('   You can buy manually at: https://pump.fun/' + tokenAddress)
    }
    
    console.log('')
    console.log('━'.repeat(50))
    console.log('✨ DEPLOYMENT COMPLETE')
    console.log('')
    console.log('Next steps:')
    console.log('1. npm run post-tweets  (Post launch thread)')
    console.log('2. npm run deploy-page  (Update landing page)')
    console.log('3. npm run monitor      (Start monitoring)')
    console.log('━'.repeat(50))
    
    return tokenAddress.trim()
    
  } catch (error) {
    console.error('')
    console.error('❌ Deployment failed:', error.message)
    
    // Take screenshot for debugging
    await page.screenshot({ path: join(projectRoot, 'error-screenshot.png') })
    console.error('   Screenshot saved to: error-screenshot.png')
    
    throw error
    
  } finally {
    if (!HEADLESS) {
      console.log('')
      console.log('Browser will close in 5 seconds...')
      await page.waitForTimeout(5000)
    }
    
    await browser.close()
  }
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  deployToken()
    .then(address => {
      console.log('')
      console.log('Token Address:', address)
      process.exit(0)
    })
    .catch(error => {
      console.error(error)
      process.exit(1)
    })
}

export { deployToken }
