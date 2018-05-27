---
title: Tuning Racecars with Black Box Optimization
category: misc
layout: post
permalink: /tuning-racecars-with-black-box-optimization/
---

*Note that I have no affiliation with the game mentioned in this post*

I take somewhat of a guilty pleasure in playing car racing games on my phone.
Every now and then when I get bored I find the hottest racing game on the Play
Store and sink some time into it.  As a car guy who doesn't currently own a car,
I think this provides some sort of outlet for me to live vicariously through my
avatar.

| ![car.png]({{site.file}}/images/race_car.png) |
|:--:|
| *My most recent car at the time of writing this post* |

The latest game I've been into, appropriately titled "[Drag Racing: Streets](https://play.google.com/store/apps/details?id=mobi.square.sr.android&hl=en_US)",
has a relatively complex racing engine. There are a number of tunable car parameters
which affect your car's speed in different ways. These parameters fall into two categories: suspension and transmission.

| ![suspension.png]({{site.file}}/images/suspension_tune.png) | ![transmission.png]({{site.file}}/images/transmission_tune.png) |
|:--:|
| *Suspension parameters* | *Transmission parameters* |

Tuning these parameters to optimize your car's speed is a pretty tedious job.
After spending a non-trivial amount of time searching for the best settings, I
put on my software engineering hat and decided to work smart and not hard. I
realized that since these parameters are bounded, and there exists a well defined
objective function (the time it takes for the car to travel some distance) it
should be possible to use an algorithm to efficiently traverse the search
space.

## Black box optimization

Black box optimization is a problem solving technique which attempts to minimize
(or maximize) the output of some function *f* with respect to a set of bounded
input parameters. The name comes from the fact that the algorithm makes no
assumptions about the underlying function, it is treated as an opaque entity
which takes input and provides output. Generally black box optimizers are
designed to minimize the number of times the objective function is queried,
as it is assumed to be expensive.

Optimizing my car's suspension and transmission seemed like a task which fit well with this
paradigm, so I wrote up a short script which utilized the [blackbox](https://github.com/paulknysh/blackbox) python library, and was off to the races (pun intended).

<script src="https://gist.github.com/Quinny/d414fb36fcfdc0d8bb5d13880cc7f3ef.js"></script>

## Results

### Suspension Tuning

The suspension tuning worked surprisingly well. The optimizer actually converged
on values very close to what I had worked out originally. At the advice of the
optimizer I reduced my front tire pressure slightly and inched up my back springs
and found that my car ran 0.2 seconds faster in the quarter mile, which is a
noticeable improvement.


### Transmission Tuning

Unfortunately the optimizer failed to provide a sensible transmission tune.
Unlike the suspension parameters, the transmission parameters have some
constraints within themselves. That is, the gear ratios should be strictly
decreasing from 1st to 4th gear. Since the optimizer I used did not support
constraints, the model failed to converge to this pattern within a reasonable
amount of time.

## Future Work

### Constrained Optimization

The optimizer I used did not support constrained optimization. I.e. Find the
best gear ratios r1, r2, r3, r4 such that r1 > r2 > r3 > r4. These constraints
would significantly reduce the search space and help the optimizer converge
faster, allowing it to throw away invalid configurations. The [scipy package
includes constrained optimization libraries](https://docs.scipy.org/doc/scipy/reference/tutorial/optimize.html#constrained-minimization-of-multivariate-scalar-functions-minimize) which may be of help here.

### More Parameters Per Run

In the interest of time and my own sanity I only tuned two parameters at a time.
This means that the optimizer wasn't able to fully measure the effect different
parameters have on each other (e.g. how changing the gear ratios may effect the
suspension). Introducing some constraints as discussed above may reduce the search
enough to make doing this viable.
