# TSKV Construction - AWS Deployment Info

| Resource | Value |
|----------|-------|
| **Live URL** | https://dui212y9d8yzm.cloudfront.net |
| **S3 Bucket** | tskv-construction-website-784060240662 |
| **CloudFront Distribution ID** | E2E8QXA2HSJGTT |
| **CloudFront Domain** | dui212y9d8yzm.cloudfront.net |
| **AWS Region** | us-east-1 |
| **AWS Account** | 784060240662 |

## Redeploy

```bash
./scripts/deploy.sh
```

## GitHub Actions Secrets

Set these in GitHub repo → Settings → Secrets → Actions:

- `AWS_ACCESS_KEY_ID` — (already configured locally)
- `AWS_SECRET_ACCESS_KEY` — (already configured locally)
- `AWS_REGION` = `us-east-1`
- `S3_BUCKET` = `tskv-construction-website-784060240662`
- `CLOUDFRONT_DISTRIBUTION_ID` = `E2E8QXA2HSJGTT`
