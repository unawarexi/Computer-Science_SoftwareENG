📡 Top 50 Questions + Answers — Wireless & Connectivity

(for Flutter & React Native)

⚙️ 1 – 10 : General Connectivity Concepts

How would you check network connectivity in both stacks?
• Flutter → connectivity_plus, internet_connection_checker
• React Native → @react-native-community/netinfo

How would you respond to connectivity changes in real time?
Subscribe to stream/listener → update UI state or retry queue.

Walk me through the flow of detecting network type (Wi-Fi, 4G, 5G).
• NetInfo.fetch() / Connectivity().checkConnectivity() returns connection type.
• Store result → adjust data strategy.

Why is it important to handle airplane-mode events?
Prevent false retries; pause sync tasks until connectivity resumes.

How would you implement background reconnection logic?
Background service monitors connectivity → triggers queued uploads when online.

What’s the best way to handle captive portals (hotel Wi-Fi)?
Test small HTTPS ping to known host before assuming true internet.

How do you detect and handle low-bandwidth mode?
RN → NetInfo.details.isConnectionExpensive; Flutter → manual speed test or OS hint.

How can apps adapt to metered networks?
Defer heavy downloads or switch to text-only mode.

Explain network “handover.”
Automatic switch between Wi-Fi ↔ cellular; maintain sockets via reconnect logic.

What is connection pooling?
Reuse TCP connections → lower latency for multiple API calls.

📶 11 – 20 : Wi-Fi & Bandwidth Optimization

Walk me through connecting to a Wi-Fi network programmatically.
• Flutter → wifi_iot, network_info_plus (Android-only).
• RN → react-native-wifi-reborn.

How to read SSID and signal strength?
Same libraries expose RSSI/SSID; permissions required (location).

Why should apps not auto-connect to arbitrary Wi-Fi networks?
Security / privacy; must require explicit user consent.

What’s the difference between 2.4 GHz and 5 GHz Wi-Fi for mobile apps?
5 GHz → faster / shorter range; can influence streaming quality.

How can you test app bandwidth programmatically?
Download known-size file → measure duration → compute throughput.

How do you throttle data usage in low-bandwidth environments?
Reduce image sizes, pre-compress payloads, use pagination.

How would you stream large files efficiently?
Chunked upload/download + resume token; parallel ranges.

How to cache media while respecting bandwidth?
Use adaptive bitrate or partial caching; prefer background Wi-Fi syncs.

Explain QoS and its relevance.
Quality of Service — prioritizes latency-critical packets (VoIP, real-time).

What’s the impact of packet loss and how to mitigate?
Retries, FEC (for media), smaller packet payloads.

📲 21 – 30 : Bluetooth & BLE

How do you enable Bluetooth access?
Flutter → flutter_blue_plus, flutter_reactive_ble.
RN → react-native-ble-plx.

Walk me through the BLE connection flow.
Scan → discover device → connect → discover services → read/write characteristics.

How do you handle Bluetooth permissions across OS versions?
Android 12+ = BLUETOOTH_SCAN, BLUETOOTH_CONNECT; iOS = NSBluetoothAlwaysUsageDescription.

How do you maintain BLE stability in background?
Background isolate/service + periodic reconnect logic.

How would you stream sensor data via BLE?
Subscribe to notify characteristics → batch + debounce for UI.

What are MTU and throughput considerations?
Max Transfer Unit = bytes per packet; tune for data vs power trade-off.

How can you pair securely with BLE devices?
Use LE Secure Connections + bonding; confirm via PIN / NFC tap.

How do you detect BLE availability?
API check before scan; listen to state events (onStateChange).

How to handle device reconnection?
Cache device ID → auto-retry with exponential backoff.

Why prefer BLE over Classic Bluetooth for mobile apps?
Lower power consumption; designed for IoT data bursts.

💳 31 – 40 : NFC and Proximity Communication

Walk me through NFC data exchange flow.
Detect → read tag → parse NDEF → trigger action (open URL, auth).

Which Flutter and RN packages handle NFC?
Flutter → flutter_nfc_kit, nfc_manager; RN → react-native-nfc-manager.

What’s NDEF?
NFC Data Exchange Format – standardized record container.

How do you write custom data to an NFC tag?
Create NDEF record → write with tag session active.

How do you secure NFC transactions?
Encrypt payloads + validate app signatures.

How to emulate an NFC card (HCE)?
Android only: Host Card Emulation API + flutter_nfc_emulator.

How to handle multiple tag scans quickly?
Queue reads → debounce tag callbacks.

How would you detect NFC availability on a device?
Check API isAvailable / isSupported.

What are limitations of NFC on iOS?
Limited tag types, no background scans except via App Clip Triggers.

When would you pick NFC over Bluetooth?
Instant tap pairing / auth use cases (no manual setup).

🌍 41 – 50 : Advanced Wireless Integrations & Resilience

How do you manage simultaneous connections (BLE + Wi-Fi)?
Separate threads / isolates; OS handles radio co-existence.

Explain peer-to-peer (P2P) data transfer options.
Wi-Fi Direct, Bluetooth, WebRTC local mesh.

How can WebRTC be used for wireless data?
P2P via STUN/TURN – low-latency multimedia sharing.

What is Nearby Share / AirDrop-style implementation pattern?
Local discovery + Wi-Fi Direct transfer + OS intent permission.

How do you measure signal strength programmatically?
RSSI metrics via Wi-Fi or BLE APIs.

What’s the role of multicast/broadcast sockets?
LAN device discovery or IoT commands.

How do you handle radio permission revocation mid-session?
Listen to system callbacks → graceful disconnect + user prompt.

What’s best practice for data sync under unstable connectivity?
Use queued transactions + background resumable uploads.

How would you test app performance across different network types?
Use Network Link Conditioner / Android emulator throttling.

What KPIs indicate good wireless UX?
• Connection success > 95 %
• Avg handover < 2 s
• Battery impact < 5 % session
• Retry rate < 3 %

🧠 Senior Takeaways

Always treat connectivity as dynamic — never assume online.

Architect for offline-first + graceful reconnects.

Handle BLE/NFC permissions robustly.

Optimize for bandwidth / power balance.

Include telemetry & network profiling for production monitoring.