Run server:
shotgun

Run tests:
rspec 

To trigger endpoint you can use this curl:

curl -X POST -H "Content-Type: text/plain" --data "2018-06-12 09:41 A recommends B
2018-06-14 09:41 B accepts
2018-06-16 09:41 B recommends C
2018-06-17 09:41 C accepts
2018-06-19 09:41 C recommends D
2018-06-23 09:41 B recommends D
2018-06-25 09:41 D accepts
"  http://127.0.0.1:9393/rewards/calculate  

notes:
- from task description, we only processing request input, so I didn't use any databases
- code organized using different well-known patters (should be easy to read and understand)
- to represent connections between customers I decided to use Btree (because a picture of connections looks like a tree :) )
- test coverage: only necessary tests
- RSpec for tests
- for points calculations, I decided to use BigDecimal (so we have correct arithmetic here)
- no additional libraries like robocop, N+1 query finded and etc (I'm the only one developer on this app)


Task description:

Concept

A company is planning a way to reward customers for inviting their friends. They're planning a reward
system that will give a customer points for each confirmed invitation they played a part into. The definition
of a confirmed invitation is one where an invited person accepts their contract. Inviters also should be
rewarded when someone they have invited invites more people.

The inviter gets (1/2)^k points for each confirmed invitation, where k is the level of the invitation: level 0
(people directly invited) yields 1 point, level 1 (people invited by someone invited by the original customer)
gives 1/2 points, level 2 invitations (people invited by someone on level 1) awards 1/4 points and so on.
Only the first invitation counts: multiple invites sent to the same person don't produce any further points,
even if they come from different inviters and only the first invitation counts.

So the input of

2018-06-12 09:41 A recommends B

2018-06-14 09:41 B accepts

2018-06-16 09:41 B recommends C

2018-06-17 09:41 C accepts

2018-06-19 09:41 C recommends D

2018-06-23 09:41 B recommends D

2018-06-25 09:41 D accepts

would calculate as:

A receives 1 Point from the recommendation of B, 1⁄2 Point from the recommendation of C by B and
another 1⁄4 Point by the recommendation of D by C. A gets a total score of 1.75 Points.


B receives 1 Point from the recommendation of C and 1⁄2 Point from the recommendation of D by C.


B receives no Points from the recommendation of D because D was invited by C before. B gets a
total score of 1.5 Points.


C receives 1 Point from the recommendation of D. C gets a total score of 1 Point.


Task

Implement the solution using Ruby.

Briefly document the decisions you’ve taken in the process and why you’ve chosen so.

Test your implementation against the data provided.

Provide a simple Webservice accepting a file with input data and returning a set of scores for the
contained customers. (Example: { “A”: 1.75, “B”: 1.5, “C”: 1 })
