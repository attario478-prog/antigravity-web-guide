#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${PROJECT_ID:-}"
REGION="${REGION:-us-central1}"
SERVICE_NAME="${SERVICE_NAME:-antigravity-api}"

if [[ -z "$PROJECT_ID" ]]; then
  echo "Set PROJECT_ID first. Example: export PROJECT_ID=my-project" >&2
  exit 1
fi

echo "Building backend image..."
docker build -t "us-docker.pkg.dev/${PROJECT_ID}/containers/${SERVICE_NAME}:latest" ./backend

echo "Pushing image..."
docker push "us-docker.pkg.dev/${PROJECT_ID}/containers/${SERVICE_NAME}:latest"

echo "Deploying to Cloud Run..."
gcloud run deploy "$SERVICE_NAME" \
  --image "us-docker.pkg.dev/${PROJECT_ID}/containers/${SERVICE_NAME}:latest" \
  --region "$REGION" \
  --platform managed \
  --allow-unauthenticated \
  --memory 4Gi \
  --cpu 2 \
  --timeout 3600

echo "Done."
