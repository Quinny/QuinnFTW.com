---
title: A non-scary C++ Bloom Filter Implementation
layout: post
permalink: /c++-bloom-filter/
category: not-scary
---
A bloom filter is a space efficient data structure which answers the question of
"Do you contain this element?" with either "Maybe" or "Definitely not".  Bloom
filters trade-off the total confidence of a typical hash set with a huge reduction
in memory.

# How do they work?

Under the hood a bloom filter is just an array of bits.  Initially, all bits are set to 0.
When an item is inserted, it is hashed with <code>K</code> different hash functions.
These hash functions provide <code>K</code> indices into the bit array, which are
all flipped from 0 to 1.

<img src="{{site.file}}/images/bf1.jpg"/>

> Inserting "Cat" and "Dog" into a bloom filter with <code>K=2</code> different
> hash functions.

It then follows that an item is "Maybe" in the bloom filter if for each of
its hash indices, the corresponding bit is set to 1.  Why only maybe?  There is
no such thing as the "perfect" hash function, consequently collisions introduce
a probability for error.

<img src="{{site.file}}/images/bf2.jpg"/>

> "Bird" collides with other entries.  This means that the Bloom filter
> would identify "Bird" as maybe being a member of the set, when in reality it's
> not.

The upside is that if any of the hash indices are 0 for a given
element, we can be 100% confident that element is not in the set.  This means
that Bloom filters can produce <b>false positives</b> but never
<b>false negatives</b>.

# Memory Savings v.s. a Typical Hash Set

<i>Beware, sketchy math ahead</i>

There is some fancy math on the [wikipedia](https://en.wikipedia.org/wiki/Bloom_filter)
page that states fewer than 10 bits per item is required for a 1% false
positive rate.  Lets assume we want to store 1,000,000 ASCII strings with an
average length of 10 characters.

For a bloom filter this would require:
<table border="1">
<td>10 bits per element</td>
<td>10,000,000 bits</td>
<tr>
<td>Total size</td>
<td>1.19MB</td>
</tr>
</table>

<i>Note that the actual size of the data does not influence the size of the table.</i>

For a hash set with an 80% occupancy rate this would require:
<table border="1">
<tr>
<td>1,200,000 32 bit pointers</td>
<td>38,400,000 bits</td>
</tr>
<tr>
<td>1,000,000 32 bit hash values</td><td>32,000,000 bits</td>
</tr>
<td>1,000,000 10 byte strings for collision checking</td>
<td>80,000,000 bits</td>
</tr>
<tr>
<td>Total size</td>
<td>18.75MB</td>
</tr>
</table>

The space savings are pretty large if you can afford a 1% margin for error.


# Implementation

Bloom filters are pretty straight forward, the one catch is: **Where the hell
do we get all these hash functions?**  In practise it is not feasible to have to
write <code>K</code> hash functions for some potentially large <code>K</code> value.
A commonly used trick is to use a single hash function, and seed a uniform random
generator with the output.  This generator can then be used to compute each of the <code>K</code>
"hash values."

<script src="https://gist.github.com/Quinny/59e84676fbbafe05317fa9d852c5012b.js"></script>


# Practical Applications

* [Yahoo email contact check](https://www.quora.com/What-are-the-best-applications-of-Bloom-filters)
* [Malicious website verification](http://stackoverflow.com/questions/14403383/bloom-filter-usage)
