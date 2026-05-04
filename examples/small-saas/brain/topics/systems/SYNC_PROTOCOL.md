# SYNC_PROTOCOL — How Quill's sync works

> **What this file answers**: How does the sync engine work? What does the server see? What can't it see?

---

## Threat model

The user's notes are personal — the server **must not** be able to read them, even under subpoena, even if the server is compromised. The server's job is purely to ferry encrypted blobs between the user's devices.

## Encryption

Each user has a sync key derived from their license key + a per-user salt:

```
sync_key = PBKDF2(license_key + user_salt, iterations=100_000)
```

The license key never leaves the user's devices except during initial activation (HTTPS to license worker only, never to sync worker). The sync key is derived locally on each device.

All file content sent to the server is encrypted with `sync_key` using AES-256-GCM. The server sees only ciphertext + a file ID + a timestamp.

## Sync flow

1. **On file save**: the local file's content + metadata is hashed. If the hash differs from the last-synced hash, mark as dirty.
2. **On sync trigger** (every 30s when active, or on demand): batch all dirty files, encrypt each, POST to `worker/sync` with `(file_id, ciphertext, mtime, content_hash)`.
3. **Server stores** in R2 with TTL of 7 days. Updates KV index for "what files changed for user X since timestamp T."
4. **Other devices poll**: GET `worker/sync?since=<timestamp>` → list of changed file IDs → fetch each ciphertext → decrypt locally.

## Conflict detection

When a device receives a remote change for a file, it compares:
- Remote `content_hash` vs local `content_hash`
- Remote `mtime` vs local file's `mtime`

Three cases:
- **Hashes match**: no actual change, skip
- **Local mtime > remote mtime AND hashes differ**: local is newer, push local up (no-op for this device)
- **Local mtime ≠ remote mtime AND hashes differ AND both edited since last shared sync point**: **conflict** — surface to user via `editor/ConflictView.tsx`

## What the server can see

- File IDs (UUIDs, not names)
- Encrypted blob sizes (allows traffic analysis of "approximate note size")
- Timestamps of sync activity
- Device IDs (per-user, locally generated UUIDs)

## What the server cannot see

- File names (filename is in metadata blob, also encrypted)
- File contents
- Folder structure
- Whether the user has 3 notes or 30,000

## Why this design

User trust > engineering convenience. We chose strict E2EE even though it costs us debuggability — we cannot help a user recover a corrupted blob, for instance. The decision is logged in `DECISIONS.md` (2026-03-12 — Cloudflare Workers).

## Related

- `worker/src/index.ts` — server side
- `desktop/renderer/src/sync/SyncCrypto.ts` — encryption
- `desktop/renderer/src/sync/LocalSyncEngine.ts` — sync orchestration
