---
title: Generic Container Benchmarking
layout: post
permalink: /generic-container-benchmarking/
tag: project

scheme-text: "#1B8F00"
---

[Final Product](https://github.com/Quinny/Container-Benchmark)

<hr />

One of the things that I have been really into lately is writing my own
implementations of the containers provided in the STL.  It helps me better
understand whats going on under the hood and is great practise for writing
generic code.

One of the things I found myself doing was comparing the performance of my custom
data structures to the equivalent standard implementations and seeing
how they held up.
I found myself writing more or less the same code each time I did this, so I
decided to try my hand at writing a library to make my life easier.

Goals
========

* Report time to do basic container operations (insert, look up, copy, move, etc.)
accurately in seconds

* Be able to compare MOST (I don't want to say all) containers against each other,
regardless of different API's

* Allow the user a high level of control on how insertions and lookups are done

Reporting Time
===============

Thankfully C++ has an excellent [time library](http://www.cplusplus.com/reference/chrono/) which provides a [high resolution clock](http://www.cplusplus.com/reference/chrono/high_resolution_clock/), so this part of the library was much easier than expected.  To record time taken to complete an operation, one simply writes:

<script src="https://gist.github.com/Quinny/460823080f07cf142d6c.js"></script>

Benchmarking Inserts
=======================

This is the part where things got interesting.  I started with implementing
my insertion function.  I wanted to make it so that the same function
could be used on all the different container types.  I started to analyze the
standard containers and noticed a few patterns:

* Sequence containers generally provide both
``void push_back(T const&)`` and
``void insert(std::size_t, T const&)`` functions for adding elements

* Associative and ordered containers only use
``iterator insert(std::pair<key_type, value_type> const&)`` for inserting, and
do <b>not</b> provide a push_back function

* Limited access containers use ``void push(T const&)``

The problem now was to figure out a way to integrate all 3 of these different
insertion methods into a single (as far as the user is concerned) function.

I have recently started to learn about template metaprogramming, so I
knew that some [member detecting](http://en.wikibooks.org/wiki/More_C++_Idioms/Member_Detector) would be useful for figuring this out.

Based on my observations I came up with 3 different member dectors, one for push_back, one for insert, and one for push.  Now I could use these member dectors 
along with [std::enable_if](http://en.cppreference.com/w/cpp/types/enable_if) to choose the right overload of insert for each container type.

* If the container has a push_back function, then treat it as a seqeunce container

* If the container has a insert function and <b>does not</b> have a push_back function, treat it as associative.  The check for push_back is nessesary because
sequence containers also provide an insert function, therefore only checking for 
the presence of an insert function would lead to an ambiguous call.

* If the container has a push function, treat it as limited access

Now, where should the inserted values be coming from?  I decided to allow the 
user to provide a callable object which takes no arguments that would provide 
the values to be inserted.  I believe this allows for the highest level of control, as the user could provide a stateless function, or some kind of stateful functor.

Benchmarking Look ups
=====================

Benchmarking lookups turned out to be alot easier than insertions as there 
was only 2 different possibilites for each container:

* An ``iterator find(T const&)`` function existed

* No find function existed

I wrote up another quick member dector for a find function, and defined an 
error case for containers which did not provide one.   This makes it so that no 
compile time error will occur, and other benchmarks can continue on as expected.

I breifly considered using ``std::find()`` in the case where a find 
member function was not found but iterators for the container existed.  I decided 
against this because generally these types of contianers are not designed 
for rapid successive look ups.

Again, I allowed the user to provide a no argument callable object from which 
the look up elements would be generated.

Benchmarking Iteration
=======================

Iteration proved to be easy as well, as it followed the same pattern as look 
up functions. either:

* ``begin()`` and ``end()`` functions exist

* ``begin()`` and ``end()`` functions do not exist

I came up with a few more member dectectors, defined an error case 
and just recorded to time it took to for-range loop through each element 
in the container

Benchmarking copy and move constructors was very trivial and not worth 
the explanation.

*see* ``auto copy = c`` and ``auto m = std::move(c)``

Wrapping Up
=============

I provided a utility function which performs the benchmarks on two different 
provided containers and outputs the results in a nice colored format.

If you are interested, the code for this can be found on [github](https://github.com/Quinny/Container-Benchmark), and I welcome criticism with open arms.
