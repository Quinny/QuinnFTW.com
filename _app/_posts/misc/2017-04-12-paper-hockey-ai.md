---
title: Paper Hockey AI
layout: post
permalink: /paper-hockey-ai/
category: misc
---

<div align="center">
<img src="{{site.file}}/images/paperhockey.gif" width="10%">
</div>

This year at [CS Games](http://2017.csgames.org/) the AI challenge entailed
creating an agent for a game called "paper hockey".  Basically, each team takes
turns moving the puck in one of eight directions (4 cardinal directions plus
diagonals), and the first team to score the puck in the opposing team's net wins.
Once an edge has been moved over, the ice becomes crushed and it cannot be re-travelled.
Additionally, moving over a position that has already been visited via a different
edge awards the player with a bounce (i.e. an extra move).  A team can also win
by check-mating their opponent, this is accomplished by moving into a location
surrounded by crushed ice, thus no valid moves can be made.  The
[official README](https://github.com/Marx314/csgames_2017_ai/blob/bc9c20150b7fcb989f0117f7ccae7b017badc3bf/readme/readme-en.md)
contains more information.

# The Winning Agent

My team (consisting of two others and myself) developed the winning agent.
The GIF above depicts a particularly involved game of our bot, the DanglingPointers,
playing against Brock Universities bot.  The
[source code for our agent is available on GitHub](https://github.com/Quinny/CSGames2017AIWinner),
and the rest of this post will discuss our development/thought process throughout
the challenge.

# Board Representation

The game board can easily be interpreted as an 8-regular graph, where each section
of ice represents a node and the movements represent edges.  Since time was limited
we decided to forgo keeping track of the entire state of the board within our agent,
and went with a much simpler approach.

# First Iteration

In the interest of time, we decided to start out with a simple one state look ahead
heuristic.  Our player would move the puck to the section of ice which was closest
to the opponents goal.  Since the game board was a grid,
[Manhattan distance](https://en.wiktionary.org/wiki/Manhattan_distance) seemed
like a sensible distance function, so we went with that.

# A Better Distance Function

We quickly realized that Manhattan distance wasn't a good metric as
it only considers cardinal movements, and our agent was allowed to move diagonally.
We updated the heuristic to consider
[Euclidean distance](https://en.wikipedia.org/wiki/Euclidean_distance), and observed 
a noticeable change in performance.  [In talking to other teams I discovered
that we were not the only ones to make this mistake, many others incorrectly
used Manhattan distance as a heuristic and their bot suffered because of it.]

# Bounce Consideration

An attempt was made at considering bounces when selecting the next state.  Instead
of only considering the immediate distance to the goal,
the new algorithm would consider how close we could get to the opponents goal
accounting for how far the puck could potentially bounce.  We ultimately ended
up scraping this as it had the unfortunate side affect of heavily saturating
the game board, resulting in frequent self check mates.

# Post Shots

Moving back to the original Euclidean distance single state look ahead, we
realized that shooting the puck off of the walls provided a bounce.  Since the
posts counted as walls, one could guarantee victory from two sections away by
banking the shot off the post and then into the goal.  We thus modified our
heuristic to always take a post shot if one was available.

# Occam's Razor

In the end [Occam's Razor](https://en.wikipedia.org/wiki/Occam%27s_razor)
prevailed and a greedy one state look ahead agent out-performed its more
complicated counter parts.

<img src="{{site.file}}/images/aiteam.jpg">

> > > > > [Left to right] Patrick (team mate), Myself, Jurko (team mate),
> > > > > Mark (contest organizer)
