**Request changes** — one blocking issue, one nit.

### Blocking

- `retry.ts:42` — the backoff doubles *before* the first failure is logged, so incident logs will understate the real retry count. Log the attempt first, then back off.

### Nits

- `retry.ts:31` — extract the literal `7` into a `MAX_RETRIES` constant.

Nice cleanup otherwise.
