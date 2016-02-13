---
title: A non-scary C++ graph implementation
layout: post
permalink: /c++-graph-implementation/
category: not-scary
---

If you have ever tried to google for a C++ graph implementation you mostly likely 
came across a big heaping ([pun intended](http://gribblelab.org/CBootcamp/7_Memory_Stack_vs_Heap.html)) mess of pointers.  While this approach 
works fine, the code is very clunky and the interface tends to become awkward 
to use.

The problem with these implementations is that they do not make use of the excellent 
data structures that the C++ STL provides.  Why define everything in a low level 
manner when we can abstract all of it away with permformant higher level data structures?

At the highest level, a graph is a set of nodes connected by a set of edges.  The most 
common way to represent this relation is by using an *adjacency matrix* like so:

<img src="http://www.bytehood.com/wp-content/uploads/2012/01/adjacency_matrix.gif" />

Each node in the graph has its own row and column in the matrix.

* m[i][j] = 1 => i is connected to j
* m[i][j] = 0 => i is not connected to j

This idea can be simplified further by saying that each node has a set of adjacent 
nodes that it is connected to, i.e.

$$ i \in m[j] \implies $$ i is adjacent to j

So the adjaceny matrix above could be reduced to the following:

<pre>
{
    A : {B, C, D, E},
    B : {A, D, E},
    C : {A, F},
    D : {A, B, F},
    E : {A, B, F},
    F : {C, D, E}
}
</pre>

Essentially we have created a map, where the key is a node and the value is a set of nodes.  
The relationship that the map represents is adjacency.  C++ provides both a set and a map 
data structure, so this could be represented as follows:

<code>
std::map&lt;T, std::set&lt;T&gt;&gt; g;
</code>

Where T is the node payload type.  In order to connect node i to node j, 
we simply add j to i's set (and vice versa if the graph is bidirectional).

<code>
g[i].insert(j);
</code>

To disconnect nodes i and j, simply remove j from i's set

<code>
g[i].erase(j);
</code>

The full code for this representation is about 16 lines, and is enough to implement 
almost any graph algorithm (small modifications/additions must be made for some 
of the more complicated algorithms).

<script src="https://gist.github.com/Quinny/a92c42c628983ef3142c.js"></script>

Usage Example
-----------------

# Breadth First Search

<script src="https://gist.github.com/Quinny/0d5351607f3cefd1aa13.js"></script>
