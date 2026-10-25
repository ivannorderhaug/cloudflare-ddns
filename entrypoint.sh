#!/usr/bin/env bash
set -euo pipefail

# Allow a single update or a custom command: docker run ... IMAGE /app/cloudflare-ddns
if (( $# > 0 )); then exec "$@"; fi

: "${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN environment variable is required}"
: "${CLOUDFLARE_ZONE_ID:?CLOUDFLARE_ZONE_ID environment variable is required}"
: "${CLOUDFLARE_DNS_RECORDS:?CLOUDFLARE_DNS_RECORDS environment variable is required}"
UPDATE_INTERVAL_SECONDS="${UPDATE_INTERVAL_SECONDS:-300}"
if [[ ! "$UPDATE_INTERVAL_SECONDS" =~ ^[1-9][0-9]{0,6}$ ]]; then
  echo "UPDATE_INTERVAL_SECONDS must be an integer from 1 to 9999999 seconds" >&2
  exit 1
fi

CHILD=''
stop() {
  trap - TERM INT
  if [[ -n "$CHILD" ]]; then
    kill -TERM "$CHILD" 2>/dev/null || true
    wait "$CHILD" 2>/dev/null || true
  fi
  exit 0
}
trap stop TERM INT

echo "Checking DNS now and every $UPDATE_INTERVAL_SECONDS seconds"
while true; do
  /app/cloudflare-ddns &
  CHILD=$!
  if wait "$CHILD"; then
    date +%s > /tmp/ddns-last-success
    echo "DNS check succeeded"
  else
    echo "DNS check failed; retrying in $UPDATE_INTERVAL_SECONDS seconds" >&2
  fi
  sleep "$UPDATE_INTERVAL_SECONDS" &
  CHILD=$!
  wait "$CHILD"
done
