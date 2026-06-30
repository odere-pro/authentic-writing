The outage started at 2am, and by the time I woke up the dashboards were a wall of red.

The API was flat on its back, and the workers were limping — half-processing jobs, half-dropping them. I made coffee and started reading logs, the way you do when the only honest move left is to slow down and look.

By 3am I had it: a connection pool that quietly exhausted itself the moment traffic doubled. Obvious in hindsight. They always are.
