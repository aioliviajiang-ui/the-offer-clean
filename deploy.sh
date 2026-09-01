#!/bin/bash
PROJECT_NAME="${1:-the-offer-oli}"

# 从 wrangler OAuth 配置读取 token，用于非交互式部署
WRANGLER_CONFIG="${HOME}/Library/Preferences/.wrangler/config/default.toml"
if [ -f "$WRANGLER_CONFIG" ] && [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  export CLOUDFLARE_API_TOKEN=$(grep '^oauth_token' "$WRANGLER_CONFIG" | head -1 | sed 's/.*= "//;s/"$//' | tr -d '\n')
fi

echo "==> Deploying to Cloudflare Pages project: $PROJECT_NAME"
npx wrangler pages deploy . --project-name "$PROJECT_NAME"
