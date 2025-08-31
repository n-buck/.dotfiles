#!/usr/bin/env bash
TMP_FILE=/tmp/firefly-iii-file.text
pdftotext $1 $TMP_FILE

FILE=`cat $TMP_FILE`
IBAN=`cat $TMP_FILE | sed '0,/^IBAN/d' | tail +2 | head -n 1`
DATE=`cat $TMP_FILE | sed '0,/^Valutadatum/d' | tail +2 | head -n 1`
AMOUNT=`cat $TMP_FILE | sed '0,/^Auszahlung/d' | tail +4 | head -n 1`
BENEFICIARY=`cat $TMP_FILE | sed '0,/^Begünstigter/d' | tail +2 | head -n 1`
BENEFICIARY2=`cat $TMP_FILE | sed '0,/^Begünstigter/d' | tail +3 | head -n 1`

IFS=.
read -r -a DATE_ARRAY <<< $DATE
IFS=$' \t\n'

DATE=${DATE_ARRAY[2]}-${DATE_ARRAY[1]}-${DATE_ARRAY[0]}T00:00:00+00:00
TRANSACTION_TYPE=withdrawal

generate_post_data()
{
  cat <<EOF
{
  "error_if_duplicate_hash": false,
  "apply_rules": false,
  "fire_webhooks": true,
  "transactions": [
    {
      "type": "$TRANSACTION_TYPE",
      "date": "$DATE",
      "amount": "$AMOUNT",
      "description": "$BENEFICIARY",
      "notes": "$BENEFICIARY2",
      "source_name": "Swissquote"
    }
  ]
}
EOF
}

API_IP=192.168.1.50
API_PORT=9080
TRANSACTION_URL="http://$API_IP:$API_PORT/api/v1/transactions"

curl -X POST $TRANSACTION_URL \
  -H "accept: application/vnd.api+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data "$(generate_post_data)"

