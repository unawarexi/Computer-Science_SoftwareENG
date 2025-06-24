# Solidity Storage Deep Dive (with Foundry Context)

This document explains how storage works in Solidity and how it's represented on-chain, with practical Foundry usage for developers. It covers storage slots, layout, packing, variable types, and how to test or manipulate storage using Foundry.

---

## 1. What Is Storage?

Storage refers to the permanent, persistent state of a contract that is written to the Ethereum blockchain. It’s expensive (gas-wise) and is stored in key-value pairs — each variable is stored at a 32-byte (256-bit) storage slot.

---

## 2. Storage Slot Layout

- Each contract has a separate storage layout
- Solidity stores state variables in contiguous slots, starting from `slot 0`
- Each slot is 32 bytes
- Variables are packed into a slot only if they can fit together

### Example

```solidity
uint128 a = 1; // takes 16 bytes
uint128 b = 2; // fits in same slot as `a` (slot 0)
uint256 c = 3; // takes full slot (slot 1)
```

| Slot | Variable(s)                  |
|------|------------------------------|
| 0    | a (16 bytes) + b (16 bytes)  |
| 1    | c                            |

---

## 3. Packing Rules (Gas Optimization)

- Variables of smaller types (uint8, uint16, etc.) can be packed into one slot
- Ordering matters: group small types together
- Reference types (like mapping, array, string, bytes) get their own slots

---

## 4. How Mappings and Arrays Work

### Mappings

Mappings don't store data in slots directly. Instead, they compute a hash to store values:

```solidity
mapping(uint => uint) data;
// Value for data[5] is stored at:
keccak256(abi.encode(5, slot_of_mapping))
```

### Dynamic Arrays

```solidity
uint[] arr;
// slot N: stores length
// Elements:
keccak256(N)        → arr[0]
keccak256(N) + 1    → arr[1]
...
```

---

## 5. Storage vs Memory vs Calldata

| Location   | Persistent? | Cost   | Use Case                          |
|------------|-------------|--------|-----------------------------------|
| storage    | Yes         | High   | State variables                   |
| memory     | No          | Medium | Temporary values inside functions |
| calldata   | No (read-only) | Low | Function parameters (external)    |

---

## 6. Inspecting Storage with Foundry

Use `vm.load(address, slot)` to inspect a contract's storage directly.

**Example Test in Foundry:**

```solidity
function testStorageSlot() public {
    MyContract c = new MyContract();
    bytes32 value = vm.load(address(c), bytes32(uint256(0))); // slot 0
    console.logBytes32(value);
}
```

Use this to verify internal storage layout, especially after deployment or fuzzing.

---

## 7. Storage Visibility

| Modifier   | Description                                    |
|------------|------------------------------------------------|
| public     | Generates getter function                      |
| internal   | Accessible within contract & inheriting contracts |
| private    | Only accessible within defining contract       |
| external   | Not valid for storage variables (only functions) |

---

## 8. Storage in Foundry Unit Tests

Foundry allows in-depth manipulation of storage, such as:

- Set a storage slot manually:

    ```solidity
    vm.store(address(contract), bytes32(slot), bytes32(newValue));
    ```

- Cheat with fuzzing or injection:  
  You can force state into any storage slot to simulate edge cases.

---

## 9. Constants and Immutables

- `constant` values are stored in bytecode, not storage
- `immutable` values are set in the constructor and stored in special storage slots (behind the scenes) — cheaper than regular storage

---

## 10. Gas Costs of Storage

| Operation                         | Approx Gas |
|------------------------------------|------------|
| Storage read                       | ~200       |
| Storage write (from 0 to non-zero) | ~20,000    |
| Storage write (non-zero to another non-zero) | ~5,000 |
| Delete (set to zero)               | Refund up to ~15,000 |

- Writing to storage is very expensive
- Avoid frequent or unnecessary writes
- Use events/logs for off-chain data where possible

---

## 11. Storage in Upgradeable Contracts

- You must preserve the exact slot layout between upgrades
- Use tools like OpenZeppelin’s Initializable and Storage Gap patterns
- Never re-order or delete state variables between versions

---

## 12. Foundry Tips for Storage Debugging

- Use `forge inspect Contract storage-layout` to inspect storage slots
- Use `forge build --sizes` to see compiled contract sizes
- Use `forge test -vvvv` and `vm.load/store` to trace tricky storage bugs

---

## 13. References

- Solidity Docs: Storage Layout
- Foundry Cheatcodes: vm.load
- EVM Deep Dive

---

## Final Notes

- Storage is core to security and gas optimization in smart contracts
- Misusing storage can introduce reentrancy, overwrites, and upgrade bugs
- Mastering storage helps you write safe, cheap, and scalable contracts