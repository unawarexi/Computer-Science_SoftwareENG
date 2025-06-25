// UI and style logic

const connectButton = document.getElementById("connectButton")
const balanceButton = document.getElementById("balanceButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const statusDot = document.getElementById("statusDot")
const walletStatus = document.getElementById("walletStatus")
const balanceDisplay = document.getElementById("balanceDisplay")
const balanceAmount = document.getElementById("balanceAmount")
const messageDisplay = document.getElementById("messageDisplay")
const messageText = document.getElementById("messageText")
const ethAmountInput = document.getElementById("ethAmount")

let isConnected = false

export function setButtonLoading(button, loading) {
  if (loading) {
    button.classList.add("loading")
    button.disabled = true
  } else {
    button.classList.remove("loading")
    button.disabled = false
  }
}

export function showMessage(message, type = "success") {
  messageText.textContent = message
  messageDisplay.className = `message ${type} show`
  setTimeout(() => {
    messageDisplay.classList.remove("show")
  }, 5000)
}

export function updateWalletStatus(connected) {
  isConnected = connected
  if (connected) {
    statusDot.classList.add("connected")
    walletStatus.textContent = "Wallet Connected"
    connectButton.innerHTML = '<i class="fas fa-check"></i> Connected'
    connectButton.style.background = "linear-gradient(45deg, #10b981, #059669)"
  } else {
    statusDot.classList.remove("connected")
    walletStatus.textContent = "Wallet Disconnected"
    connectButton.innerHTML = '<i class="fas fa-wallet"></i> Connect'
    connectButton.style.background = "linear-gradient(45deg, #7c3aed, #a855f7)"
  }
}

export function updateBalanceDisplay(balanceEth) {
  balanceAmount.textContent = `${balanceEth} ETH`
  balanceDisplay.classList.add("show")
}

export function getIsConnected() {
  return isConnected
}

export function setIsConnected(val) {
  isConnected = val
}

ethAmountInput.addEventListener("input", (e) => {
  const value = parseFloat(e.target.value)
  if (value < 0) {
    e.target.value = ""
  }
})

window.addEventListener("load", () => {
  document.body.style.opacity = "1"
})
