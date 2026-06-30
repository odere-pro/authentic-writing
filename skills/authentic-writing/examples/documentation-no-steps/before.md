# Configuring the Cache

The cache layer sits between the API and the database. It is important for performance and you should configure it carefully depending on your workload and traffic patterns, which vary a lot between deployments.

There are several settings that matter, and getting them wrong can cause stale reads, so be thoughtful about it.
