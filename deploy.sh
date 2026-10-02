steps:
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'build'
      - '-t'
      - 'us-docker.pkg.dev/$PROJECT_ID/containers/antigravity-backend:$SHORT_SHA'
      - '-f'
      - 'backend/Dockerfile'
      - 'backend'

  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'push'
      - 'us-docker.pkg.dev/$PROJECT_ID/containers/antigravity-backend:$SHORT_SHA'

  - name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    entrypoint: gcloud
    args:
      - 'run'
      - 'deploy'
      - 'antigravity-api'
      - '--image'
      - 'us-docker.pkg.dev/$PROJECT_ID/containers/antigravity-backend:$SHORT_SHA'
      - '--region'
      - 'us-central1'
      - '--platform'
      - 'managed'
      - '--allow-unauthenticated'
      - '--memory'
      - '4Gi'
      - '--cpu'
      - '2'
      - '--timeout'
      - '3600'
      - '--set-env-vars'
      - 'GOOGLE_CLOUD_PROJECT=$PROJECT_ID'

  - name: 'node:20'
    dir: 'frontend'
    entrypoint: 'bash'
    args:
      - '-c'
      - 'npm install && VITE_API_URL=https://antigravity-api-xxxxx-uc.a.run.app npm run build'

images:
  - 'us-docker.pkg.dev/$PROJECT_ID/containers/antigravity-backend:$SHORT_SHA'

options:
  logging: CLOUD_LOGGING_ONLY
