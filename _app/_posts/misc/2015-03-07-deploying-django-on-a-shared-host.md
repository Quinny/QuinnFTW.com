---
title: Deploying django on a shared host
layout: post
permalink: /deploying-django-on-a-shared-host/
category: misc
---

I finally decided to suck it up and rewrite [linkwallet](http://linkwallet.ca) in django.  I got sick of trying to maintain the messy PHP code that I had written and hacked onto over the years.

It took me about a month of on and off work, but it was finally ready to be pushed to production.  Now I have expirience with pushing rails to production using heroku, but never have I pushed django to production.  On top of that, I wanted to push it to my shared host (bluehost) as I have already paid for 3 years of hosting (I know), and am pretty happy with their speeds and features (ssh access, unlimited emails, etc.).  It wasn't really as easy as I had hoped it would be so I figured it
would be helpful for me, and maybe others, if I documented the process and outlined the mistakes I made.

<hr />

Step 1 - Install Python
============================
The first thing I had to do was get python installed on my shared host.  Thankfully bluehost offers ssh access, so doing this was pretty straight forward.  One mistake I made which I payed for later on was that I installed a different version of python on the server than on my local machine.

*Dont do this*

Initially I installed python 2.7.5, whereas my local environment was running 2.7.7.  I ran into an issue with the hmac.compare_digest function which caused numerous 500 errors which were not fun to track down.

To install python on your shared host, ssh into the server and from the home directory run the following commands:

{% highlight sh %}
mkdir src
cd src
wget http://www.python.org/ftp/python/<version>/Python-<version>.tgz
tar -xzvf Python-<version>.tgz
cd Python-<version>
./configure --prefix=$HOME/python
make
make install
{% endhighlight %}

Where you would replace ```<version>``` with the version of python you are using.

Step 1.1 - Update your path
----------------------------

Now you have to update your ```$PATH``` so that when you run the ```python``` command, it uses your python instead of the system installed one.  To do this simply run ```vim ~/.bashrc``` (vim optional, use whatever text editor you want) and add the line ```export PATH=$HOME/python/bin/:$PATH```.  This makes it so that ```python``` will resolve to your version instead of the system one.

<hr />

Step 2 - Install Django
=======================

The easiest way to install Django and all its dependancies is through pip.  To install pip, run the following commands from your ```src``` directory:

{% highlight sh %}
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
{% endhighlight %}

Now we can use pip to install django with:

{% highlight sh %}
pip install django
{% endhighlight %}

There is one other thing that we need to run django through fastcgi called flup.  This can also be installed through pip with:

{% highlight sh %}
pip install flup
{% endhighlight %}

<hr />

Step 3 - Transferring files
===========================

This step can be done many different ways, so I will leave this one up to you.  Basically you need to get your django project files from your local machine to the server.
I prefer to store them somewhere in the home directory, but its really up to.

<hr />

Step 4 - Route requests through your django app
===============================================

Now that your project is on the server, you need to route your requests through it somehow.
Change directories into the root of your website (where you would normally store index.html, etc.), and create a file called ```<yoursite>.fcgi``` (obviously replacing ```<yoursite>``` with the name of your site) and add the following:
{% highlight python %}
#! /home/<yourusername>/python/bin/python

import sys
import os

sys.path.insert(0, "/home/<yourusername>/python/lib/python2.7/site-packages")
sys.path.append("<full path to your django project>")

os.environ["DJANGO_SETTINGS_MODULE"] = "<your project name>.settings"

from django.core.servers.fastcgi import runfastcgi
runfastcgi(method="threaded", daemonize="false")
{% endhighlight %}

Again, filling in your information.

chmod this file so that it can be executed:
{% highlight sh %}
chmod 0755 <yoursite>.fcgi
{% endhighlight %}

And now running ```./<yoursite>.fcgi``` should output the html code of your index page to the screen.

In order to route http requests to this script, you need to create a ```.htaccess``` file in your website route (same directory as the fcgi file) which contains the following:

{% highlight sh %}
AddHandler fcgid-script .fcgi
RewriteEngine On
RewriteCond %{HTTP_HOST} ^(.+\.|)<your site url>.com
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ <yoursite>.fcgi/$1 [QSA,L]
{% endhighlight %}

<hr />

Thats it
==========

If you did everything right, you should be able to load yoursite.com and see your newly created django site in action.
Now go turn debug to false and fix the other 800 errors that pushing to production caused ;)
