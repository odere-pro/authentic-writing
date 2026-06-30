# Configuring the Cache

The cache layer sits between the API and the database. This guide is for operators setting it up for the first time.

## Prerequisites

- Redis 7+ reachable from the API hosts.

## Steps

1. Set `CACHE_URL` to your Redis connection string.
2. Set `CACHE_TTL` (seconds). Start with `300`.
3. Restart the API and confirm `cache: connected` in the logs.

## Example

```bash
export CACHE_URL=redis://localhost:6379
export CACHE_TTL=300
```

## Common pitfalls

- A TTL of `0` disables expiry and causes stale reads.
