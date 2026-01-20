⚡ TOP 50 DATA OPTIMIZATION QUESTIONS & ANSWERS (React Native + Flutter)
🔸 1–10: General Data Flow & Architecture

How would you design a data flow for large-scale apps in Flutter or React Native?
→ Use layered architecture: Data Source → Repository → Use Cases → UI.
Flutter: Repository + Provider/Bloc
RN: Repository + React Query/Zustand/Redux
Ensures isolation of logic, reusability, and clean testability.

Walk me through how you would optimize data fetching in mobile apps.
→ Apply lazy loading, pagination, caching (Hive/AsyncStorage), and batch requests. Always debounce API calls and cache results locally.

How do you minimize redundant network calls?
→ Use request deduplication (React Query, Dio interceptors), cache responses, and apply ETag or If-None-Match headers on APIs.

How would you handle heavy JSON data responses?
→ Stream parsing (e.g., compute() in Flutter isolates, JSON.parse() in RN worker thread). Avoid decoding on UI thread.

How would you optimize your app to handle 100k+ records efficiently?
→ Use pagination, indexed local DB (Hive, SQLite), and on-demand list virtualization (FlatList/LazyList).

How would you structure local persistence for performance?
→ Separate hot data (cached) vs cold data (archived). Use Hive/Sembast/SQLite (Flutter) or MMKV/AsyncStorage/WatermelonDB (RN).

How would you minimize app startup data load?
→ Lazy hydrate data post-splash. Use background initialization or parallel async fetch after rendering the first frame.

How do you reduce data redundancy across app screens?
→ Use shared repository pattern or global caching layer (React Query/Bloc). Store normalized data in a single source of truth.

When do you use in-memory cache vs persistent cache?
→ In-memory: transient, session-based data.
Persistent: reusable data (auth tokens, user profiles) or offline-first syncs.

How would you handle concurrent data updates from multiple sources?
→ Apply optimistic updates with rollback logic and versioning or timestamp-based merge reconciliation.

🔹 11–20: Caching, Offline & Local Storage

Walk me through the process of setting up offline-first architecture.
→

Detect network state

Queue mutations offline

Persist to Hive/AsyncStorage

Sync on reconnect
Flutter: connectivity_plus + Hive + Isolates
RN: NetInfo + MMKV + BackgroundTask

How do you decide what data to cache?
→ Cache data that’s immutable or expensive to re-fetch (e.g., user profiles, config). Use TTL (Time To Live) or cache invalidation policy.

How would you handle cache invalidation efficiently?
→ TTL expiration, versioning, or lastModified timestamps from server-side metadata.

Why use Hive (Flutter) or MMKV (React Native) for high-speed caching?
→ Both are key-value stores written in native code (Rust/C++). They outperform JSON-based AsyncStorage or SharedPreferences.

How would you compress stored data to save space?
→ Use Gzip or Brotli compression for serialized blobs before persisting to disk.

How do you handle image caching in both stacks?
→
Flutter: cached_network_image
RN: react-native-fast-image
Use memory + disk cache layers with LRU eviction policies.

How do you sync local data when online again?
→ Use sync queues: compare local dirty flags or timestamps → send diffs → update remote → clear sync queue.

Why should you use batch writes over single writes?
→ Reduces I/O operations and lock contention. Most DBs (Hive, SQLite, WatermelonDB) allow batch insert/update.

How would you protect cached data?
→ Encrypt local cache using AES or platform secure storage.
Flutter: flutter_secure_storage, RN: react-native-encrypted-storage.

How do you prevent cache bloat in mobile apps?
→ Use LRU policy, size limits, and background jobs to purge old caches periodically.

🔸 21–30: Serialization & Data Transfer Optimization

How would you optimize JSON serialization/deserialization?
→
Flutter: use code generation (json_serializable, freezed)
RN: use superjson or direct destructuring to reduce parse depth.

Why is code-gen serialization faster in Flutter?
→ It avoids reflection and uses compile-time type resolution.

How would you handle deeply nested JSONs efficiently?
→ Normalize them into flatter structures, extract necessary subfields, and cache computed maps.

Why use protobuf or msgpack over JSON?
→ They offer smaller payload size and faster serialization/deserialization.

How would you handle large media uploads efficiently?
→

Use chunked/multipart uploads

Background queue

Retry failed chunks

Optimize compression (e.g., image_compression or sharp)

How would you optimize REST API responses?
→ Add pagination, selective field projection (GraphQL fragments or REST filters), and compression headers.

Why use GraphQL for complex data models?
→ Avoid over-fetching/under-fetching. Fetch only required fields per screen.

When should you prefer REST over GraphQL?
→ REST is simpler, better for caching, and less CPU-heavy for mobile.

Why use HTTP/2 or gRPC over HTTP/1.1?
→ Multiplexed streams reduce latency and overhead on multiple parallel API calls.

How would you optimize data encryption overhead?
→ Use lightweight ciphers (AES-GCM), and encrypt only sensitive payloads, not the entire dataset.

🔹 31–40: Network Performance, Memory & Concurrency

How would you minimize bandwidth usage in mobile apps?
→ Compress payloads, cache aggressively, debounce user-driven requests, and use delta updates.

Why use background isolates (Flutter) or worker threads (RN)?
→ To offload CPU-heavy JSON parsing or file I/O from the main thread.

How would you manage concurrent API requests efficiently?
→ Use concurrency pools (limit parallel fetches to 3–5). Await all with Future.wait() or Promise.all().

Why is WebSocket data more efficient than polling?
→ It maintains a persistent connection, sending delta updates only — reducing network chatter.

How do you handle memory pressure caused by large datasets?
→ Use lazy lists (ListView.builder / FlatList), dispose controllers, and free memory with clear() calls on caches.

How would you detect memory leaks in data-heavy apps?
→
Flutter: DevTools Memory Tab, RN: Flipper, Chrome Profiler.

Why is immutability important in data models?
→ Prevents unintended side-effects and makes caching predictable.

How do you handle streaming data efficiently?
→ Use async streams (Dart Stream, RN EventEmitter) with throttling/debouncing.

How do you detect and handle data synchronization conflicts?
→ Use timestamps, conflict resolution strategies, or last-write-wins policies.

Why is pagination critical for mobile performance?
→ Avoids large payloads, prevents frame drops, and keeps memory footprint minimal.

🔸 41–50: Advanced Data Strategies & Best Practices

How would you design a multi-source data merge (remote + cache + local)?
→ Merge priority: memory cache → persistent cache → network.
Emit updates progressively as fresher data arrives.

How do you keep app data lightweight across versions?
→ Schema migrations: remove obsolete fields, compress old data, clear stale caches on version bump.

Why is database indexing critical?
→ Reduces query time from O(n) to O(log n). Always index frequently filtered columns.

How would you optimize search queries locally?
→ Use FTS (Full-Text Search) in SQLite or maintain precomputed search indices.

Why use data normalization before caching?
→ Prevents redundant entities and ensures consistent updates across views.

How would you optimize synchronization frequency?
→ Adaptive sync intervals — based on user activity, battery level, and network quality.

Why use data versioning?
→ To handle schema evolution, migration, and compatibility between old/new API responses.

How do you maintain app responsiveness during heavy data tasks?
→ Use isolates/workers, show placeholders, prefetch only visible data, and schedule background syncs.

Why is prefetching critical in user-heavy apps?
→ Reduces perceived latency by preloading next-view data (e.g., recommended products, next chat messages).

How would you monitor and measure data performance?
→ Track API latency, cache hit ratios, serialization time, memory usage — via Firebase Performance, Flipper, or Dart DevTools.