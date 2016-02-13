---
title: A non-scary C++ trie implementation
layout: post
permalink: /c++-trie/
category: not-scary
---

Tries are a lesser known, but very useful data structure.  A trie (or prefix tree)
is an ordered tree data structure, such that each descendant of a given node in a trie share
a common prefix.  This property makes for fast prefix based queries (used in auto complete, spell check, etc.).

<img src="{{site.file}}/images/trie.jpg" />

> A trie with words a, at, ate, on, one, out, my, me, and mud.
> Filled in nodes denote the end of a word.

Implementing a trie is similar to implementing any other n-ary tree, with a few key differences.

## The Node

Each node in a trie has a set of outgoing edges labeled by a character.  Each
node must also contain a flag indicating whether it is a valid word end.

Outgoing edges can be represented by a map of ``char => node*``.

``n[c] => m`` denotes that n has an outgoing edge labeled c, incident on m.

The end of word marker can be represented trivially by a boolean field.

Our node ends up looking like this:
<script src="https://gist.github.com/Quinny/960f872f88ca86b741cc.js"></script>

## The Trie

As with most tree-like structures, the only data member required for a trie
is a node which points to the root.

To insert into a trie, you simply iterate through the input string and walk the corresponding edge labels.
If a given edge does not exist, create it.  Once you have exhausted the input string, mark the node
you ended on as a valid end of word.

<script src="https://gist.github.com/Quinny/b2e09745aee0e60e5414.js"></script>


Since trie_nodes are being dynamically allocated on the heap, they must be deleted.
The destructor for a trie needs to walk the tree and de-allocate all nodes.
This can be implemented using either a DFS or BFS traversal (I tend to prefer BFS)

<script src="https://gist.github.com/Quinny/6a3079fc7d552eee76ee.js"></script>

With these functions, you have a working trie.  You can now begin to add functions
which perform the prefix queries.  I have shown an example below.

## Auto complete

<script src="https://gist.github.com/Quinny/a837587eb986434bf03a.js"></script>
