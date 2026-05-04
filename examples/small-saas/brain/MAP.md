# MAP — Project Map

> **What this file answers**: "What does the project look like? Where do I find specific information?"
> **Who reads this**: **first thing every new session reads**.

---

## 1. Quick start

**Run the project (dev mode)**:
```bash
npm run dev
```
Starts Vite frontend (port 5173) + Python sync-server (port 8801) + Electron shell.

**Key entry points / ports**:
- Electron main process: `desktop/main.js`
- Python sync server: `server/sync.py`, listens on `http://localhost:8801`
- React frontend: `desktop/renderer/src/App.tsx`, dev port 5173
- Cloudflare Worker (production sync): `worker/src/index.ts`, deployed to `quill-sync.example.com`

**Health check**:
```bash
curl http://localhost:8801/api/health        # local dev sync
curl https://quill-sync.example.com/health   # production sync
```

**Build a release `.dmg` / `.exe`**:
```bash
npm run dist:mac      # ~10 minutes
npm run dist:win      # ~8 minutes
```

## 2. Module list

| Module | Responsibility | State | Main location |
|---|---|---|---|
| **Electron desktop shell** | App lifecycle, file system access, menus | Stable | `desktop/` |
| **Markdown editor** | CodeMirror 6 + custom keybindings | Stable | `desktop/renderer/src/editor/` |
| **Local SQLite store** | File metadata, full-text search index, sync state | Stable | `desktop/renderer/src/store/` |
| **Sync engine** | File-level diff sync, conflict detection | **Active development (v0.4)** | `desktop/renderer/src/sync/` |
| **Cloudflare Sync Worker** | Encrypted blob relay, device pairing | Stable | `worker/` |
| **License Worker** | Stripe webhook → license key generation → email | Stable | `worker/license/` |
| **Settings UI** | Preferences, sync setup, license activation | Stable | `desktop/renderer/src/settings/` |

## 3. Module dependencies

```
User
 └─▶ Electron shell ──spawn──▶ Renderer process
                                  ├──▶ Local SQLite (notes metadata + FTS)
                                  ├──▶ File system (the .md files themselves)
                                  └──▶ Sync engine ──HTTPS──▶ Cloudflare Sync Worker
                                                                └──▶ R2 (encrypted blobs, 7-day TTL)

Independent path:
Stripe Payment Link ──webhook──▶ License Worker ──KV──▶ License key → Resend email → User
                                                  │
                                                  └──validation endpoint──▶ App
```

**Key isolation**: notes content never goes through the Cloudflare Worker as plaintext — only client-side encrypted blobs. The Worker can't read your notes even if it wanted to. See `topics/systems/SYNC_PROTOCOL.md`.

## 4. Continuity layer 5 core files

| File | Answers | When to read |
|---|---|---|
| `PROJECT.md` | Origin, non-goals | First contact, scope ambiguous |
| `MAP.md` | Module structure, doc index | Every session |
| `STATUS.md` | Current state, next step | Every session |
| `HANDOFF.md` | Previous session's window-switch handoff | Every session (if exists) |
| `DECISIONS.md` | Historical decisions | Tracing why something is the way it is |

`handoffs/` — historical HANDOFF archive directory (empty for now; populates each window-switch).

## 5. Topic docs (`brain/topics/`)

### systems/
| File | What it is | When to read |
|---|---|---|
| `SYNC_PROTOCOL.md` | How file-level diff sync works, encryption, conflict detection | Touching the sync engine; debugging sync issues; user asks "can you read my notes?" |

### operations/
| File | What it is | When to read |
|---|---|---|
| `RELEASE_CHECKLIST.md` | Pre-release red lines | Every release before tagging |

### planning/
| File | What it is | When to read |
|---|---|---|
| `MOBILE_ROADMAP.md` | Mobile platform strategy (deferred to v1.0+) | When considering mobile work; when users ask about iOS/Android |

### feedback/
| File | What it is | When to read |
|---|---|---|
| `BUG_TRACKER.md` | Active bugs by ID + status | Triaging new feedback; pre-release sweep |

---

## 6. MAP self-calibration

**Triggers for update**:
- Module added / removed / state change → update §2
- Major restructure → update §2 + §3
- New / removed / heavily revised topic doc → update §5
- Run command changes → update §1

**Calibration scan** (run when user says "MAP calibration" or after a major structural change):
- Files in `topics/` not registered in §5 → "unregistered files"
- §5 entries pointing to non-existent files → "stale entries"
- §5 entries whose description disagrees with file content → "drifted entries"

The `scripts/doctor.sh` tool automates checks 1-2 of the calibration.
