# Export button does nothing on the Reports page

## Summary

Clicking "Export CSV" on `/reports` since v2.4.0 produces no download and no error.

## Steps to reproduce

1. Open `/reports`.
2. Click "Export CSV".

## Expected vs actual

- Expected: a CSV file downloads.
- Actual: nothing happens; no network request fires.

## Environment

- v2.4.0, Chrome 126, macOS.

## Proposed direction

The click handler appears unbound after the reports refactor in #1180.

## Acceptance criteria

- [ ] Clicking Export downloads a CSV.
- [ ] A regression test covers the handler.
