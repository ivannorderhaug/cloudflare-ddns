#!/usr/bin/env bash
set -euo pipefail

[[ -s /tmp/ddns-last-success ]]
read -r LAST_SUCCESS < /tmp/ddns-last-success
(( $(date +%s) - LAST_SUCCESS <= ${UPDATE_INTERVAL_SECONDS:-300} + 300 ))
