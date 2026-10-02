# Antigravity Web App Starter

This Vite + React frontend connects to the FastAPI backend and streams Antigravity tool output in real time.

## Setup

```bash
npm install
cp .env.example .env
npm run dev -- --host 0.0.0.0
```

## Environment

Create a `.env` file with:

```env
VITE_API_URL=http://localhost:8080
```

In production, point this to your Cloud Run URL.

## Build

```bash
npm run build
```

## Notes

This frontend is intentionally lightweight and focused on a minimal chat UI. It is designed to be extended with authentication, model selection, and project preview screens.
