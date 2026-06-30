# Vector Search Spike

## Question

Can pgvector serve our semantic search at acceptable latency without a separate vector DB?

## Verdict

Conditional yes — fast enough up to ~100k embeddings with an HNSW index; revisit beyond that.

## Setup

pgvector 0.7, 100k embeddings (1536-dim), HNSW and IVFFlat indexes compared.

## Results

- p50 latency ~40ms with HNSW; ~90ms with IVFFlat.
- Recall@10 ~0.95 with HNSW at our build settings.

## Limitations

Tested at 100k rows only; behavior at 1M+ is unknown.

## Recommendation

Ship pgvector for now; re-evaluate a dedicated store if the corpus passes ~500k.
