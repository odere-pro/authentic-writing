# Q2 Reliability Review

## Executive summary

Four incidents in Q2, three caused by the cache layer. Total downtime 47 minutes, all customer-facing. The single highest-leverage fix is a cache connection-pool guard; we recommend prioritizing it in Q3.

## Findings

- 3 of 4 incidents traced to cache pool exhaustion under traffic spikes (fact).
- The Q2 deploy regression slipped past review because it lacked an eval gate (interpretation).

<!-- GRAPH: incidents per month, Q1 vs Q2 -->

## Recommendations

1. Add a cache pool-exhaustion guard and alert.
2. Require an eval gate on deploys touching the cache.

## Decisions log

- Approved: pool guard (owner: SRE, due Q3).
