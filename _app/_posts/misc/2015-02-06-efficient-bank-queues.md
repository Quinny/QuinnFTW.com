---
title: Efficient Bank Queues
layout: post
permalink: /efficient-bank-queues/
category: misc
---

<script type="text/javascript" async src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

One of my friends who is taking a data structures class recently came to me for help with an interesting problem.  A formal description of which can be found [here][1] (see part C).

Basically, you are asked to simulate two different styles of queues in a public place (for the purpose of this post I will be referring to a bank), and indicate which style results in a shorter mean wait time. 

Series Queueing
-------
Each teller has his/her own queue.  When a customer arrives, they will enter  the shortest queue in terms of people in the queue.  Once a customer has chosen a queue, they will not change queues (renege), or decide to leave before they have been served (balk).

Parallel Queuing
-------
All tellers share a common queue, and serve the next customer once they become available.

The first time I read this question, I expected series queueing to be the better option, as it results in n queues moving concurrently.  After having researched a bit on [queue theory][2] (which I didn't know existed before having seen this problem) I learned that parallel is in fact better.

The reason why this is the case is because with series queueing, a single slow customer will cause his/her entire line longer wait times.  Whereas with parallel queueing, one teller can help that slow customer while the rest of the customers flow to the other available tellers.

In more precise terms, the wait time for a customer in series queueing can be calculated as $$ \sum f(customer_i) $$ where $$ f(x) = time\ required\ to\ serve\ x $$  As you can see, if any one customer has a large wait time it increases the wait time of each customer behind them.  The relation is very linear.

In contrast, parallel queuing produces an n-ary tree structure (where n is the number of tellers).  When a customer is at the front of the queue, they must only wait $$ min(\ f(x_i),\ f(x_{i+1}), ...,\ f(x_n)\ ) $$.  Hence a customers wait time only depends on the minimum wait time of the customers in front of them, instead of the summation.


Parallel queuing is also a better option from a psychological stand point.  Since there is only one line, it removes the frustration of a customer choosing the "slower" line.  A frustrated customer is more likely to take longer to be served than a non-frustrated customer.  Also, in a real life situation a person would not take the time to count the number of people in each queue and choose the shortest one.  Un-optimal choices would result in even more frustration and longer wait
times. Parallel queuing eliminates the need to make optimal choices, as their is only one option. 

Real life applications
----------------------

Why is it then that many commercial places uses series queuing instead of parallel queueing?  Lack of knowledge aside, series queueing is much more space efficient.  A popular application of series queueing is in toll booths on busy bridges.  Hundreds of cars are able to fit in a relatively small plaza in multiple lines, whereas if there was only one line, some kind of zig-zag or spiral formation would be needed.  With these kind of formations issues arise.  Most people are not
capable of forming a single line without the need of a physical barrier, so one must be built.  But now consider the situation where a car breaks down, how do the cars behind it continue on through the queue?  The barrier must be made wide enough to fit two cars.  Surely people will take advantage of this and attempt to cut others in line, creating another issue.

In a vacuum parallel queueing is the better option, but there are many situations where it is just not plausible.

Simulation
----------

I wrote up a quick C++ program which simulates these two queuing styles and shows the mean wait times.  I found that when the variance on $$ f(x) $$ was small, the difference in mean wait time was negligible.  When as I increased this variance it was apparent that parallel queuing was the more efficient option.  The source code to that program can be found [here][3] 


[1]: http://gamebrains.ca/254/Labs/lab4.pdf
[2]: http://en.wikipedia.org/wiki/Queueing_theory 
[3]: https://gist.github.com/Quinny/e81ab2e73f2e545acd31
