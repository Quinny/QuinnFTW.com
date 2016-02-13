---
title: Using Angular with Jekyll
layout: post
permalink: /using-angular-with-jekyll/
category: misc
---
Earlier today I decided to try and clean up some of the jquery soup on my 
website by bringing some nice and orgainized angular into the mix. 
For about 30 minutes I was pulling my 
hair out trying to figure out why my angular expressions weren't working, until 
I finally realized that angular and liquid markdown share the exact same expression 
delimiters: {% raw %}``{{`` and ``}}``{% endraw %} (just getting those to show 
in this post took some leg work).  So the liquid markdown parser scans through and 
consumes all the angular expressions and then when the html is rendered, there is 
nothing for angular to evaluate.

Thankfully angular exposes its interpolate provider, so you can easily change 
the characters to something else which won't conflict with jekyll, 
like ``[[`` and ``]]`` for example.

<script src="https://gist.github.com/Quinny/a250d1dabbc75eb8ea16.js">
</script>
