#!/usr/bin/env bash
set -euo pipefail

# Deploy TSKV Construction website to AWS S3 + CloudFront
# Usage: ./scripts/deploy.sh [bucket-name] [cloudfront-distribution-id]

BUCKET_NAME="${1:-${S3_BUCKET:-tskv-construction-website}}"
CLOUDFRONT_ID="${2:-${CLOUDFRONT_DISTRIBUTION_ID:-}}"

echo "==> Deploying to S3 bucket: ${BUCKET_NAME}"

# Sync static files to S3
aws s3 sync . "s3://${BUCKET_NAME}" \
  --exclude ".git/*" \
  --exclude ".github/*" \
  --exclude "scripts/*" \
  --exclude "README.md" \
  --exclude ".gitignore" \
  --exclude "assets/images/mockup-reference.png" \
  --delete \
  --cache-control "public, max-age=31536000" \
  --exclude "index.html" \
  --exclude "css/*" \
  --exclude "js/*"

# Upload HTML/CSS/JS with shorter cache for faster updates
aws s3 cp index.html "s3://${BUCKET_NAME}/index.html" \
  --cache-control "public, max-age=0, must-revalidate" \
  --content-type "text/html"

aws s3 sync css/ "s3://${BUCKET_NAME}/css/" \
  --cache-control "public, max-age=86400" \
  --content-type "text/css"

aws s3 sync js/ "s3://${BUCKET_NAME}/js/" \
  --cache-control "public, max-age=86400" \
  --content-type "application/javascript"

aws s3 sync assets/ "s3://${BUCKET_NAME}/assets/" \
  --cache-control "public, max-age=31536000"

echo "==> S3 sync complete"

# Invalidate CloudFront cache if distribution ID is provided
if [ -n "${CLOUDFRONT_ID}" ]; then
  echo "==> Invalidating CloudFront cache: ${CLOUDFRONT_ID}"
  aws cloudfront create-invalidation \
    --distribution-id "${CLOUDFRONT_ID}" \
    --paths "/*"
  echo "==> CloudFront invalidation initiated"
else
  echo "==> No CloudFront distribution ID provided, skipping cache invalidation"
fi

echo "==> Deployment complete!"
