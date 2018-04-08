---
layout: page
title: Blog
permalink: /blog/
desc: A few inner ramblings
---

<h2>Latest Posts</h2>
{% for post in site.posts limit:3 %}
  {% include themes/{{ site.theme }}/includes/page-item.html %}
{% endfor %}

<h2>TL;DR</h2>
{% for post in site.categories.tldr %}
  {% include themes/{{ site.theme }}/includes/page-item.html %}
{% endfor %}

<h2>Non-scary C++</h2>
{% for post in site.categories.not-scary %}
  {% include themes/{{ site.theme }}/includes/page-item.html %}
{% endfor %}

<h2>Problem of the week</h2>
{% for post in site.categories.potw %}
  {% include themes/{{ site.theme }}/includes/page-item.html %}
{% endfor %}

<h2>Misc.</h2>
{% for post in site.categories.misc %}
  {% include themes/{{ site.theme }}/includes/page-item.html %}
{% endfor %}


