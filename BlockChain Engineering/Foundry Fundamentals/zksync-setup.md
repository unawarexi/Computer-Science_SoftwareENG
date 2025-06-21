# 1. Installation

## A. Install with foundryup-zksync

```bash
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

This toolchain installs ZKsync-compatible versions of:

- `forge` & `cast` (with `--zksync` extensions)
- `anvil-zksync` for local zkEVM nodes

**Note for Windows users:** Use Git Bash or WSL due to script compatibility issues.

## B. Revert to Vanilla Foundry

After using ZKsync, return to standard Foundry with:

```bash
foundryup
```

And switch back via:

```bash
foundryup-zksync
```

## C. From source or CI

Use:

```bash
foundryup-zksync --branch main
# or
cargo install --git https://github.com/matter-labs/foundry-zksync --profile release --locked forge cast
```

Supports GitHub Actions via `dutterbutter/foundry-zksync-toolchain@v1`.

# 2. Configuration (`foundry.toml`)

Add a zksync profile:

```toml
[profile.zksync]
enable_eravm_extensions = true  # enables system contract calls
no_zksync_reserved_addresses = true
```

Also configure Etherscan-like API for explorers:

```toml
[etherscan]
zksync_sepolia = { chain = "300", url = "...", key = "APIKEY" }
```

# 3. Build & Compile

Vanilla EVM:

```bash
forge build
```

ZKsync:

```bash
forge build --zksync
```

Generates dual artifacts (EVM + zkEVM) in `zkout/` alongside `out/`.

# 4. Testing

Run tests using ZKsync VM:

```bash
forge test --zksync
```

This triggers compilation via zksolc, migrates storage, and runs tests in zk context.

You can also enable zk context via flags:

- `--zk-startup` for switching during test setup
- `--zk-compile` for zk-specific compilation

# 5. Deployment

Using `forge create` with `--zksync`:

```bash
forge create \
  src/Counter.sol:Counter \
  --zksync \
  --rpc-url <ZKSYNC_RPC> \
  --chain 300 \
  --account <KEYSTORE_NAME> \
  --from <KEYSTORE_ADDRESS> \
  --constructor-args "42" \
  --verify \
  --verifier-url <EXPLORER_API_URL> \
  --etherscan-api-key $ZKSYNC_API_KEY
```

Cast can also deploy:

```bash
cast send <CONTRACT> <FUNCTION> --rpc-url ... --chain 300 --account myKeystore --sender <KEYSTORE_ADDRESS>
```

# 6. Cast (CLI Usage)

With forge-zksync fork, cast now supports zk-Era:

```bash
cast chain-id --rpc-url ...
cast balance <addr> --rpc-url ...
cast send ...
cast call <contract> "greet()(string)" --rpc-url ...
cast to-ascii <hex-output>
```

For example on Sepolia zk:

```bash
cast call <GREETER_ADDR> "greet()(string)" --rpc-url https://sepolia.era.zksync.dev --chain 300
```

# 7. Switching: Vanilla ⇄ ZKsync

Use `foundryup` or `foundryup-zksync` to toggle toolchains.

Watch for PATH overrides; ensure correct forge binary.

On macOS, run `brew install libusb` if encountering missing library errors.

# 8. Key Differences vs Vanilla Foundry

| Feature                | Vanilla Foundry         | ZKsync Foundry (`--zksync`) |
|------------------------|------------------------|-----------------------------|
| Compile                | forge build            | forge build --zksync        |
| Test                   | forge test             | forge test --zksync         |
| Deploy                 | forge create           | forge create --zksync       |
| Local Node             | anvil                  | anvil-zksync support        |
| Storage & Address Behaviors | Normal EVM        | Respects zk reserved slots  |
| Bytecode Generator     | solc                   | zksolc for zkEVM output     |
| Explorer Verification  | Etherscan              | Abscan / ZKscan using --verify |

# Migration Tips

- Install ZKsync toolchain.
- Configure `foundry.toml` for zksync profile.
- Recompile using zk flags to generate dual artifacts.
- Modify tests to avoid reserved addresses (<65536) or set fuzz option.
- Deploy with `--zksync` to target zk-Era network.
- Cast interactions: use chain ID 300 and zk RPC URLs.

# Resources

- [Foundry-ZKsync Book](https://foundry-book.zksync.io)
- [ZKsync Docs on Foundry](https://docs.zksync.io)
- [GitHub repo & code](https://github.com/matter-labs/foundry-zksync)
- Example with Abstract/Lens guides

# Summary

With minimal changes, you can move your Solidity workflow from Ethereum to ZKsync:

- Install `foundryup-zksync`
- Use new flags on compile, test, and deploy (`--zksync`)
- Adjust configurations and tests
- Toggle back anytime with `foundryup`

Let me know if you'd like a ready-made sample project or a GitHub Actions pipeline to automate this setup!