## Everything I Learned About AI Workflows This Year

I want to share **everything** I have learned this year about adopting AI tooling on an engineering team, because it has been a long and winding road and I think there are a lot of lessons in here that other teams could benefit from if they are just getting started on this journey themselves right now.

When we first started, we did what everyone does: we opened a chat window and we started prompting the model one task at a time, and at first it felt magical, because the model could do things that would have taken us hours in just a few seconds, and we were genuinely excited about the productivity gains that we were seeing across the whole team during those first few weeks of experimentation and exploration.

But then reality set in. The magic did not scale. Every engineer was prompting in their own way, every session started from scratch, and the outputs drifted wildly from one person to the next, which meant that code review became a nightmare and our conventions started to erode in ways that were really hard to catch until they had already made it into the codebase and caused problems.

So we sat down as a team and we asked ourselves a hard question: what would it look like to treat the model not as a magic box but as a system that we engineer around, with the same discipline that we bring to everything else that we build, and that question turned out to be the single most important thing we did all year.

The first thing we did was write a rule file, a single document that the agent reads first, that captures all of the conventions and context that a new engineer would need on their first day, except that the agent cannot ask questions so we had to anticipate them all in advance, which was hard but incredibly clarifying.

The second thing we did was add verification gates, because vibes are not a quality bar, and we needed a way to know objectively whether the output was good or not, so we leaned hard on tests and evals and we refused to ship anything that could not pass them, no matter how good it looked on the surface.

The third thing we did was assign one reviewer of record per change, so that accountability did not get diffused across the whole team, and that single change did more for our quality than almost anything else we tried during the entire year of experimentation.

The fourth thing we did, and honestly this is the one that surprised me the most, was to start measuring the cost of every workflow in tokens and in wall-clock time, because once we could actually see where the money and the minutes were going, we were able to route the cheap and easy tasks to smaller and faster models while reserving the expensive frontier models for the genuinely hard problems that actually needed that level of reasoning, and that single shift cut our monthly bill almost in half while making the whole team noticeably faster on the day-to-day work that makes up the bulk of what we actually do.

Anyway, this is already getting long, but I wanted to capture all of it because I think these lessons are hard won and worth sharing widely.

#AI #Engineering #SoftwareDevelopment #Leadership
