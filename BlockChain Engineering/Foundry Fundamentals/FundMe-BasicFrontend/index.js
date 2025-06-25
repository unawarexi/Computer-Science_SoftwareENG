import { ethers } from "./ethers-6.7.esm.min.js"
import { abi, contractAddress } from "./constants.js"
import {
  setButtonLoading,
  showMessage,
  updateWalletStatus,
  updateBalanceDisplay,
  getIsConnected,
  setIsConnected,
} from "./styles.js"

const connectButton = document.getElementById("connectButton")
const withdrawButton = document.getElementById("withdrawButton")
const fundButton = document.getElementById("fundButton")
const balanceButton = document.getElementById("balanceButton")
const ethAmountInput = document.getElementById("ethAmount")

connectButton.onclick = connect
withdrawButton.onclick = withdraw
fundButton.onclick = fund
balanceButton.onclick = getBalance

async function connect() {
  setButtonLoading(connectButton, true)
  if (typeof window.ethereum !== "undefined") {
    try {
      await ethereum.request({ method: "eth_requestAccounts" })
      updateWalletStatus(true)
      setIsConnected(true)
      showMessage("Wallet connected successfully!", "success")
    } catch (error) {
      showMessage("Connection failed", "error")
      updateWalletStatus(false)
      setIsConnected(false)
    }
  } else {
    showMessage("Please install MetaMask", "error")
    updateWalletStatus(false)
    setIsConnected(false)
  }
  setButtonLoading(connectButton, false)
}

async function withdraw() {
  if (!getIsConnected()) {
    showMessage("Please connect your wallet first", "error")
    return
  }
  setButtonLoading(withdrawButton, true)
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    await provider.send("eth_requestAccounts", [])
    const signer = await provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    try {
      const transactionResponse = await contract.withdraw()
      await transactionResponse.wait(1)
      showMessage("Withdraw transaction completed!", "success")
    } catch (error) {
      showMessage("Withdraw failed", "error")
    }
  } else {
    showMessage("Please install MetaMask", "error")
  }
  setButtonLoading(withdrawButton, false)
}

async function fund() {
  if (!getIsConnected()) {
    showMessage("Please connect your wallet first", "error")
    return
  }
  const ethAmount = ethAmountInput.value
  if (!ethAmount || parseFloat(ethAmount) <= 0) {
    showMessage("Please enter a valid ETH amount", "error")
    return
  }
  setButtonLoading(fundButton, true)
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    await provider.send("eth_requestAccounts", [])
    const signer = await provider.getSigner()
    const contract = new ethers.Contract(contractAddress, abi, signer)
    try {
      const transactionResponse = await contract.fund({
        value: ethers.parseEther(ethAmount),
      })
      await transactionResponse.wait(1)
      showMessage(`Successfully funded ${ethAmount} ETH!`, "success")
      ethAmountInput.value = ""
    } catch (error) {
      showMessage("Funding failed", "error")
    }
  } else {
    showMessage("Please install MetaMask", "error")
  }
  setButtonLoading(fundButton, false)
}

async function getBalance() {
  if (!getIsConnected()) {
    showMessage("Please connect your wallet first", "error")
    return
  }
  setButtonLoading(balanceButton, true)
  if (typeof window.ethereum !== "undefined") {
    const provider = new ethers.BrowserProvider(window.ethereum)
    try {
      const balance = await provider.getBalance(contractAddress)
      const balanceEth = ethers.formatEther(balance)
      updateBalanceDisplay(balanceEth)
      showMessage("Balance updated successfully!", "success")
    } catch (error) {
      showMessage("Failed to fetch balance", "error")
    }
  } else {
    showMessage("Please install MetaMask", "error")
  }
  setButtonLoading(balanceButton, false)
}
