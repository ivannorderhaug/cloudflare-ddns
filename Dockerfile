FROM alpine:3.23

RUN apk add --no-cache bash ca-certificates curl jq

WORKDIR /app
COPY --chmod=755 cloudflare-ddns entrypoint.sh healthcheck.sh ./

USER 65532:65532
ENV UPDATE_INTERVAL_SECONDS=300
ENV PATH="/app:${PATH}"
HEALTHCHECK --interval=30s --timeout=5s --start-period=120s --retries=3 \
  CMD ["/app/healthcheck.sh"]
ENTRYPOINT ["/app/entrypoint.sh"]
