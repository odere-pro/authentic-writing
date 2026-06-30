The backoff doubles before the first failure is even logged, so the logs will be misleading during an incident. Also the literal 7 in the retry loop should be a named constant.
