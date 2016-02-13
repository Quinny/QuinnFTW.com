---
layout: post
title: Personal API
tag: project

scheme-text: "#6EB3DE"
---

[Final Product](http://api.quinnftw.com)

<hr />

I've had the idea of creating a personal API rolling around in my head for a
while.  Its a pretty cool concept, and there are a lot of interesting implementation
and design decisions to be made.  My two main goals for the end product were:

<hr />

The data should be easily accessible and clean

This was a big one.   I've used a lot of poorly designed API's with nonsensical
end point names and the need for 18 different check sums to get a single piece of data.
Data cleanliness was also very important, there is no need to have to go through
an arbitrary number of outer level JSON fields before getting to the actual

<hr />

It should be very easy to add/modify end points

I wanted to design the API as an almost a plugin like system, where adding new modules
(end points) was very simple and the main driver really doesn't have to worry about
individual implementations.

<hr />

Before starting to write code or making any design decisions, I poked around
a few github repo's to see how other people were doing things.  One that I
really liked and pulled a lot of inspiration from was
[mbmccormick's personal api](http://mbmccormick.com/2015/07/personal-api/).

I decided to go with a Node.js backend because I have recently been fooling around
with node and wanted to expand my knowledge a bit.  I had also created an HTTP server in
node before and I knew it would be super easy to get up and running.  Since
I would be using javascript as the server language, it only made sense to serve
the data in JSON format.

Making the API easily extensible was actually not as difficult as I thought it would
be.  I made each API module expose a ``registerRoutes`` function which defined
loop through each of the end points and register it with the main server.  I
implemented some pretty simple cache logic and a few helper functions for
setting the HTTP headers and response content and the API was up and running
in no time.

I also wrote a janky little python script which parses each module for comments
and generates an html file with documentation.  This made it
so that the homepage literally updated it self with each new addition and I
didn't have to worry about forgetting to add to it.

I am very proud of the final product, the code is super clean and very easily testable.  The [source code](https://github.com/quinny/api) is available on
github, and the api is live at [api.quinnftw.com](https://api.quinnftw.com).

If you have any questions about anything that I did or think you can improve
my code, [let me know!](/contact/).
