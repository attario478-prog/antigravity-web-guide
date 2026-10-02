# Antigravity Web Guide

This guide explains how to build, host, and deploy an Antigravity-oriented web application in the Google Cloud ecosystem.

## 1. Recommended approach

There are three practical routes:

1. Fork Mobile Harness and keep only Antigravity (fastest)
2. Build a web app using a FastAPI backend and a React/Next.js frontend
3. Keep the project fully native Android and simplify the app to Antigravity only

For Google hosting, the strongest option is:

- Frontend: Firebase Hosting
- Backend: Cloud Run
- Secrets: Secret Manager
- Logs: Cloud Logging
- CI/CD: Cloud Build

## 2. Fastest Android path

If your goal is to get a working Antigravity-only app ASAP, use this flow:

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

This path reuses most of the proven architecture already in Mobile Harness.

## 3. Google Cloud web app pattern

### Architecture

```text
Browser
  -> Firebase Hosting (frontend)
  -> Cloud Run (FastAPI backend)
  -> Linux container with /usr/bin/agy
  -> Google API / Antigravity service
```

### Stack

- Frontend: Next.js or Vite React
- Backend: FastAPI
- Container: Docker
- Deployment: Cloud Run
- Hosting: Firebase Hosting
- Secrets: Secret Manager
- CI/CD: Cloud Build

## 4. Why this works well

The Mobile Harness repo already demonstrates the most important pieces:

- Antigravity CLI install and verification
- Google OAuth flow for sign-in
- Stream JSON event parsing
- Workspace scoping and task execution
- Tool activity emulation and output capture

These are the core pieces you need to move into a hosted web app.

## 5. Important security notes

- Cloud Run should not expose the CLI to the internet without constraints.
- OAuth tokens should stay in Secret Manager or dedicated secure storage.
- Keep all CLI execution inside a scoped workspace path.
- Serialize access to sessions and ensure each chat runs in a clean directory.

## 6. Starter backend

In this repo you will find a minimal backend under `backend/` that demonstrates:

- FastAPI app
- `/health` endpoint
- `/chat/start` endpoint
- WebSocket streaming endpoint
- session management pattern

## 7. Recommended production flow

1. Ship the web frontend on Firebase Hosting
2. Put FastAPI backend on Cloud Run
3. Use Gunicorn or Uvicorn for Cloud Run
4. Use Secret Manager for keys and OAuth config
5. Use Cloud Logging for observability
6. Add custom domain later if needed

## 8. Next steps

See `docs/antigravity-web-guide.md` for the full implementation guide and architecture notes.

---

This repository is a starter resource, not a production-grade SaaS implementation. It is designed to help you move faster while staying close to the proven Mobile Harness architecture.
