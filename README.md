# TSKV Construction Private Limited - Website

Official website for **TSKV Construction Private Limited** — a leading infrastructure and civil engineering company specializing in water supply, transmission pipelines, EPC projects, and large-scale infrastructure development across India.

**Building Trust • Delivering Quality • Creating Value**

## Tech Stack

- HTML5, CSS3, JavaScript (vanilla)
- Font Awesome icons
- Google Fonts (Montserrat, Open Sans)
- Hosted on AWS S3 + CloudFront

## Project Structure

```
├── index.html          # Main landing page
├── css/
│   └── styles.css      # All styles
├── js/
│   └── main.js         # Interactivity (slider, nav, counters)
├── assets/
│   └── images/         # Logo and images
├── scripts/
│   ├── deploy.sh       # Deploy to S3 + CloudFront
│   └── setup-aws.sh    # Bootstrap AWS infrastructure
└── .github/
    └── workflows/
        └── deploy.yml  # CI/CD pipeline
```

## Local Development

Open `index.html` directly in a browser, or serve locally:

```bash
python3 -m http.server 8080
# Visit http://localhost:8080
```

## AWS Deployment

### Prerequisites

- AWS CLI configured (`aws configure`)
- An AWS account with S3 and CloudFront access

### 1. Bootstrap AWS Infrastructure

```bash
chmod +x scripts/*.sh
./scripts/setup-aws.sh tskv-construction-website
```

Then create a CloudFront distribution in the AWS Console:
- Origin: your S3 bucket
- Origin Access Control (OAC): enabled
- Default root object: `index.html`
- Custom error response: 403/404 → `/index.html` (for SPA-like routing)

### 2. Manual Deploy

```bash
./scripts/deploy.sh tskv-construction-website YOUR_CLOUDFRONT_DISTRIBUTION_ID
```

### 3. GitHub Actions (Automated Deploy)

Add these secrets to your GitHub repository (`Settings → Secrets → Actions`):

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `AWS_REGION` | AWS region (e.g. `ap-south-1`) |
| `S3_BUCKET` | S3 bucket name |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID |

Push to `main` branch to trigger automatic deployment.

## Git Repository

```bash
git remote add origin git@github.com:VIGNESHTHANGAVEL1/TSKV-Construction.git
git push -u origin main
```

## Contact

- **Phone:** +91 9443889093
- **Email:** tskvconstruction.1234@yahoo.com
- **Address:** 4/121, TSKV Illam, Kumbakottai, Perrapancholai (P.O), Rasipuram (T.K), Namakkal – 636113
