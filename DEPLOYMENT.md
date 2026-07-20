# TSKV Construction - AWS Deployment Info

| Resource | Value |
|----------|-------|
| **Live URL** | https://tskvconstruction.in |
| **WWW URL** | https://www.tskvconstruction.in |
| **CloudFront URL** | https://dui212y9d8yzm.cloudfront.net |
| **S3 Bucket** | tskv-construction-website-784060240662 |
| **CloudFront Distribution ID** | E2E8QXA2HSJGTT |
| **CloudFront Domain** | dui212y9d8yzm.cloudfront.net |
| **Route53 Hosted Zone** | Z07316498AILILKWTJA8 |
| **ACM Certificate** | arn:aws:acm:us-east-1:784060240662:certificate/ba11ccb1-e08c-4b15-b3cf-342b636d4aeb |
| **AWS Region** | us-east-1 |
| **AWS Account** | 784060240662 |

## Custom Domain Setup (Spaceship → Route53 → CloudFront)

### Step 1 — Update nameservers at Spaceship (required)

1. Log in to [Spaceship](https://www.spaceship.com/)
2. Open domain **tskvconstruction.in** → **DNS / Nameservers**
3. Change from Spaceship default (`launch1/launch2.spaceship.net`) to **Custom nameservers**
4. Enter these **exactly**:

```
ns-59.awsdns-07.com
ns-1635.awsdns-12.co.uk
ns-1011.awsdns-62.net
ns-1120.awsdns-12.org
```

5. Save. Propagation usually takes 15 minutes to a few hours.

### Step 2 — Finish CloudFront + Route53 mapping

After nameservers are updated and the SSL certificate becomes `ISSUED`, run:

```bash
./scripts/finish-domain-setup.sh
```

This will:
- Attach `tskvconstruction.in` + `www.tskvconstruction.in` to CloudFront
- Enable HTTPS with the ACM certificate
- Create Route53 A/AAAA alias records → CloudFront

### Check certificate status

```bash
aws acm describe-certificate --region us-east-1 \
  --certificate-arn arn:aws:acm:us-east-1:784060240662:certificate/ba11ccb1-e08c-4b15-b3cf-342b636d4aeb \
  --query 'Certificate.Status' --output text
```

## Redeploy site files

```bash
./scripts/deploy.sh
```

## GitHub Actions Secrets

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | (IAM key) |
| `AWS_SECRET_ACCESS_KEY` | (IAM secret) |
| `AWS_REGION` | `us-east-1` |
| `S3_BUCKET` | `tskv-construction-website-784060240662` |
| `CLOUDFRONT_DISTRIBUTION_ID` | `E2E8QXA2HSJGTT` |
