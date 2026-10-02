# Antigravity Web App Starter

This repo is a practical starter project for building an Antigravity web app that can run on Google Cloud.

## Stack

- Frontend: Vite + React + TypeScript
- Backend: FastAPI
- Deployment: Cloud Run + Firebase Hosting
- CI/CD: Google Cloud Build

## Included

- `backend/` — FastAPI backend and Docker image
- `frontend/` — Vite React frontend starter
- `cloudbuild.yaml` — CI/CD pipeline for Google Cloud Build
- `docker-compose.yml` — local stack
- `.env.example` — environment variables template
- `deploy.sh` — deployment helper

## Quick start

### 1. Start backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main.py
```

### 2. Start frontend

```bash
cd frontend
npm install
cp .env.example .env
npm run dev -- --host 0.0.0.0
```

### 3. Open app

Visit:

```text
http://localhost:5173
```

The frontend connects to the backend at `VITE_API_URL`.

## Production deployment

This repo is set up for the following Google Cloud flow:

- Frontend on Firebase Hosting
- Backend on Cloud Run
- Secrets in Secret Manager
- Build pipeline in Cloud Build

## Notes

This is a starter project intended to accelerate development of a browser-based Antigravity app using the same core ideas from Mobile Harness.

## License

MIT
