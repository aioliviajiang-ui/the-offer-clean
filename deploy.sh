#!/bin/bash
PROJECT_NAME="${1:-the-offer-oli}"

echo "==> Deploying to Cloudflare Pages project: $PROJECT_NAME"
npx wrangler pages deploy . --project-name "$PROJECT_NAME"
