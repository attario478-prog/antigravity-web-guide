# Antigravity Web Guide

This repository is a complete starter guide and lightweight implementation scaffold for building a Google Cloud-hosted Antigravity web app.

It covers two practical paths:

1. Android-only Antigravity app by forking Mobile Harness
2. Web app version for Google Cloud Run + Firebase Hosting

This repo is intentionally practical: it gives you the docs, architecture, starter backend, and deployment examples you can adapt.

## Included

- `README.md` — project overview and quick start
- `docs/antigravity-web-guide.md` — the full technical blueprint
- `backend/main.py` — minimal FastAPI backend for streaming Antigravity sessions
- `backend/requirements.txt` — Python dependencies
- `backend/Dockerfile` — Cloud Run-compatible Docker image
- `backend/.dockerignore` — lean deployment image
- `frontend/README.md` — quick frontend starter instructions
- `.gitignore` — standard Python/Node ignores

## Quick path: Android-only Antigravity app

This is the simplest route if you want to turn Mobile Harness into an Antigravity-only Android app.

```bash
# 1. Clone
git clone https://github.com/techjarves/Mobile-Harness.git
cd Mobile-Harness

# 2. Remove non-Antigravity agents
rm app/src/main/java/com/jarves/mh/runtime/ClaudeRuntimeBridge.kt
rm app/src/main/java/com/jarves/mh/runtime/DeepSeekRuntimeBridge.kt

# 3. Update AgentDriver.kt (keep only Antigravity)
# Edit: app/src/main/java/com/jarves/mh/runtime/AgentDriver.kt

# 4. Simplify UI - show only Antigravity settings
# Edit: app/src/main/java/com/jarves/mh/ui/MainViewModel.kt

# 5. Build
./gradlew assembleDebug

# 6. Deploy
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

## Web app path

The recommended cloud stack is:

- Frontend: Next.js or Vite React app on Firebase Hosting
- Backend: FastAPI on Cloud Run
- Auth: Google OAuth or Google Identity
- Secrets: Google Secret Manager
- Logs: Cloud Logging
- CI/CD: Cloud Build

## Repository structure

```text
antigravity-web-guide/
├── README.md
├── docs/
│   └── antigravity-web-guide.md
├── backend/
│   ├── .dockerignore
│   ├── Dockerfile
│   ├── requirements.txt
│   └── main.py
├── frontend/
│   └── README.md
├── .gitignore
└── LICENSE
```

## Important notes

- Antigravity runs with a CLI and streams JSON events. The backend can proxy this to a browser client over WebSocket.
- The Android variant is easier and faster to ship.
- The cloud web version is better for multi-user access and broader hosting.
- For real production, protect OAuth, add auth sessions, and avoid exposing the CLI to the public internet without review.

## Docs

See the full guide here:

- `docs/antigravity-web-guide.md`

## License

MIT
