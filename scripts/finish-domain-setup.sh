#!/usr/bin/env bash
set -euo pipefail

# Finish custom domain setup after ACM certificate is ISSUED
# and Route53 nameservers are active at Spaceship.

ZONE_ID="Z07316498AILILKWTJA8"
CF_ID="E2E8QXA2HSJGTT"
CERT_ARN="arn:aws:acm:us-east-1:784060240662:certificate/ba11ccb1-e08c-4b15-b3cf-342b636d4aeb"
CF_DOMAIN="dui212y9d8yzm.cloudfront.net"
CF_ZONE_ID="Z2FDTNDATAQYW2"

echo "==> Checking ACM certificate status..."
STATUS=$(aws acm describe-certificate --region us-east-1 --certificate-arn "$CERT_ARN" --query 'Certificate.Status' --output text)
echo "Certificate status: $STATUS"

if [ "$STATUS" != "ISSUED" ]; then
  echo "ERROR: Certificate is not ISSUED yet. Update Spaceship nameservers first, then re-run."
  exit 1
fi

echo "==> Updating CloudFront aliases and SSL certificate..."
TMP=$(mktemp)
aws cloudfront get-distribution-config --id "$CF_ID" > "$TMP"
ETAG=$(python3 -c "import json; print(json.load(open('$TMP'))['ETag'])")
python3 << PY
import json
with open("$TMP") as f:
    data = json.load(f)
cfg = data["DistributionConfig"]
cfg["Aliases"] = {
    "Quantity": 2,
    "Items": ["tskvconstruction.in", "www.tskvconstruction.in"]
}
cfg["ViewerCertificate"] = {
    "ACMCertificateArn": "$CERT_ARN",
    "SSLSupportMethod": "sni-only",
    "MinimumProtocolVersion": "TLSv1.2_2021",
    "Certificate": "$CERT_ARN",
    "CertificateSource": "acm"
}
with open("$TMP.config", "w") as f:
    json.dump(cfg, f)
print("CloudFront config prepared")
PY

aws cloudfront update-distribution \
  --id "$CF_ID" \
  --if-match "$ETAG" \
  --distribution-config "file://${TMP}.config" \
  --query 'Distribution.{Id:Id,Status:Status,Aliases:DistributionConfig.Aliases}' \
  --output json

echo "==> Creating Route53 A/AAAA alias records to CloudFront..."
aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch "{
  \"Comment\": \"Point apex and www to CloudFront\",
  \"Changes\": [
    {
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"tskvconstruction.in.\",
        \"Type\": \"A\",
        \"AliasTarget\": {
          \"HostedZoneId\": \"$CF_ZONE_ID\",
          \"DNSName\": \"$CF_DOMAIN\",
          \"EvaluateTargetHealth\": false
        }
      }
    },
    {
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"tskvconstruction.in.\",
        \"Type\": \"AAAA\",
        \"AliasTarget\": {
          \"HostedZoneId\": \"$CF_ZONE_ID\",
          \"DNSName\": \"$CF_DOMAIN\",
          \"EvaluateTargetHealth\": false
        }
      }
    },
    {
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"www.tskvconstruction.in.\",
        \"Type\": \"A\",
        \"AliasTarget\": {
          \"HostedZoneId\": \"$CF_ZONE_ID\",
          \"DNSName\": \"$CF_DOMAIN\",
          \"EvaluateTargetHealth\": false
        }
      }
    },
    {
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"www.tskvconstruction.in.\",
        \"Type\": \"AAAA\",
        \"AliasTarget\": {
          \"HostedZoneId\": \"$CF_ZONE_ID\",
          \"DNSName\": \"$CF_DOMAIN\",
          \"EvaluateTargetHealth\": false
        }
      }
    }
  ]
}"

rm -f "$TMP" "$TMP.config"
echo "==> Done. Wait a few minutes for CloudFront deploy + DNS propagation."
echo "    https://tskvconstruction.in"
echo "    https://www.tskvconstruction.in"
