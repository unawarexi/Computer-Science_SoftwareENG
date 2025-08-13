# 🔐 The 5 Levels of Cross-Chain Security

Cross-chain systems vary greatly in **security guarantees** depending on how they move assets and data between blockchains.  
Below are the **five main security levels**, from least secure (Level 1) to most secure (Level 5, as used in Chainlink CCIP).

---

## **Level 1 — Centralized Bridge**
**Architecture:**  
- One organization or a small set of keys control all funds.
- Tokens are locked in a single smart contract or custody account.
- The operator signs transactions to release/mint tokens on the destination chain.

**Risks:**  
- **Single Point of Failure** — If the private keys are stolen or the operator acts maliciously, all funds can be stolen.
- No decentralization — trust is fully placed in one entity.

**Example:**  
- Centralized exchange “bridges” like Binance pegged tokens.

---

## **Level 2 — Decentralized Theater (Pseudo-Decentralized)**
**Architecture:**  
- Appears decentralized (multiple signers), but:
  - The signers are often controlled by the same entity or a small group.
  - Threshold multisig setups (e.g., 3-of-5) but with collusion risk.
- Uses “decentralized” branding without genuine independent operation.

**Risks:**  
- Still vulnerable to insider collusion.
- Limited fault tolerance if a small group controls the majority of signers.
- Users get a *false sense of security*.

**Example:**  
- Some early multisig-based token bridges marketed as decentralized.

---

## **Level 3 — One Network Security**
**Architecture:**  
- A single decentralized network (set of nodes) handles both:
  - Message validation
  - Message execution
- All trust is placed in this one network’s consensus.

**Risks:**  
- If this network is compromised (collusion or majority takeover), the entire cross-chain system is compromised.
- No secondary verification — attackers can push malicious messages directly to execution.

**Example:**  
- Relayer-based bridges where a single validator set signs and executes messages.

---

## **Level 4 — Multiple Network Security**
**Architecture:**  
- Multiple **independent** networks verify messages before execution.
- Execution only happens when **all networks agree**.
- This introduces **redundancy**: one compromised network is not enough.

**Risks:**  
- Lower risk than Level 3 but still:
  - Coordination complexity between networks.
  - Shared code vulnerabilities could affect all networks.
- Security still depends on how “independent” the networks really are.

**Example:**  
- Some IBC (Inter-Blockchain Communication) implementations using separate light-client verifiers.

---

## **Level 5 — Commit DON + Risk Management Network + Execution DON** (**CCIP Model**)
**Architecture:**  
- **Commit DON (Decentralized Oracle Network)**  
  - Observes source chain events, reaches consensus, and commits messages.
- **Risk Management Network (Independent)**  
  - Separately monitors all committed messages for anomalies.
  - Can **halt or flag** suspicious transactions before they execute.
- **Execution DON**  
  - Executes the message on the destination chain **only if** the Risk Management Network approves.

**Advantages:**  
- **Defense-in-Depth:** Three independent systems — compromising one does not give attackers total control.
- **Active Threat Detection:** Risk Management Network continuously monitors for unusual patterns (e.g., massive withdrawals, mismatched payloads).
- **Rate Limits & Circuit Breakers:** Prevent draining assets in one attack.

**Risks:**  
- Highly resilient but still relies on the continued independence and security of all three layers.

**Example:**  
- Chainlink Cross-Chain Interoperability Protocol (CCIP).

---

## 📊 Summary Table

| Level | Name | Control Model | Weakness |
|-------|------|--------------|----------|
| **1** | Centralized | Single entity/operator | Complete trust in one party |
| **2** | Decentralized Theater | Small group / colluding multisig | Collusion risk |
| **3** | One Network | Single decentralized validator set | Compromise of validator set |
| **4** | Multiple Networks | 2+ independent validator sets | Coordination & shared vuln risk |
| **5** | Commit DON + RMN + Exec DON | Three independent systems | Complex but most secure |

---

## 📌 Key Takeaways
- **Security increases as you add independent layers of verification.**
- The **Commit → Risk Management → Execution** model in Level 5 is the most resilient currently in production.
- Most bridge hacks occur in **Levels 1–3**, where a single compromised network or entity can drain all funds.

---

## 📚 Further Reading
- [Chainlink CCIP Whitepaper](https://chain.link/cross-chain)
- [Vitalik on Cross-Chain Security](https://vitalik.ca/general/2022/01/07/crosschain.html)
- [Chainalysis Report on Bridge Hacks](https://blog.chainalysis.com/reports/defi-bridge-hacks-2022/)
