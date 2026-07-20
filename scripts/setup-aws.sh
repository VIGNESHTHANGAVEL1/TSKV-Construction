#!/usr/bin/env bash
set -euo pipefail

# Bootstrap AWS infrastructure for TSKV Construction website
# Creates S3 bucket (static website hosting) and CloudFront distribution

BUCKET_NAME="${1:-tskv-construction-website}"
REGION="${AWS_REGION:-ap-south-1}"

echo "==> Creating S3 bucket: ${BUCKET_NAME} in ${REGION}"

# Create bucket
if [ "${REGION}" = "us-east-1" ]; then
  aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}"
else
  aws s3api create-bucket \
    --bucket "${BUCKET_NAME}" \
    --region "${REGION}" \
    --create-bucket-configuration LocationConstraint="${REGION}"
fi

# Block public access (CloudFront will use OAC)
aws s3api put-public-access-block \
  --bucket "${BUCKET_NAME}" \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Enable static website hosting
aws s3 website "s3://${BUCKET_NAME}" \
  --index-document index.html \
  --error-document index.html

echo "==> S3 bucket created and configured"
echo ""
echo "Next steps:"
echo "  1. Create a CloudFront distribution pointing to s3://${BUCKET_NAME}"
echo "  2. Configure Origin Access Control (OAC) for the S3 bucket"
echo "  3. Set default root object to index.html"
echo "  4. Add custom domain and SSL certificate (optional)"
echo "  5. Run: ./scripts/deploy.sh ${BUCKET_NAME} <cloudfront-distribution-id>"
echo ""
echo "For GitHub Actions deployment, set these secrets:"
echo "  - AWS_ACCESS_KEY_ID"
echo "  - AWS_SECRET_ACCESS_KEY"
echo "  - S3_BUCKET=${BUCKET_NAME}"
echo "  - CLOUDFRONT_DISTRIBUTION_ID=<your-distribution-id>"
