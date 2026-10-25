# Cloudflare DDNS

A small Docker service that keeps Cloudflare A records pointed at your public
IPv4 address. Checks on startup and every five minutes, updating only changed addresses.

```sh
cp .env.example .env
# Fill in your Cloudflare settings in .env.
docker compose up -d
docker compose logs -f cloudflare-ddns
```

Image: `ghcr.io/ivannorderhaug/cloudflare-ddns:latest`

| Environment variable | Value |
| --- | --- |
| `CLOUDFLARE_API_TOKEN` | Your Cloudflare API token |
| `CLOUDFLARE_ZONE_ID` | Your zone ID |
| `CLOUDFLARE_DNS_RECORDS` | Full names, e.g. `example.com www.example.com` |
| `UPDATE_INTERVAL_SECONDS` | Seconds between checks (default: `300`) |

Create a token with **Zone → DNS → Edit**, restricted to your specific zone.
No other permissions are needed. Leave IP filtering unset if your public IP
changes. [Cloudflare token setup](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/).

Separate record names with spaces or commas. Use one service per zone.
Existing TTL and proxy settings are preserved;
missing A records are skipped. The service does not create records or change
AAAA/CNAME records.
