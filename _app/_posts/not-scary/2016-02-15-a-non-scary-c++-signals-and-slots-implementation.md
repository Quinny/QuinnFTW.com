---
title: A non-scary C++ signals and slots implementation
layout: post
permalink: /c++-signals-and-slots/
category: not-scary
---

I was reading hacker news not too long ago and came across a [c++ signals
and slots implementation](https://github.com/pbhogan/Signals).  It was
very clearly implemented pre-c++11, and is pretty difficult to read.  I thought
I would try my hand at coming up with something a little more modern, taking
advantage of ``std::function``.

## Signals and slots

Signals and slots is a common way of implementing the observer pattern while
avoiding messy boiler plate code and forced inheritance.  The idea is that 
the *observable objects* can send *signals* to callable objects (*slots*).  It is
commonly used in GUI programming for handling events such as mouse clicks, button
presses, etc. but is also useful in other environments such as asynchronous message
passing.

## Designing the components

### The slot

The first thing that needed to be done was to implement the type that would be receiving
the signals.  The number one goal here was strong typed-ness.  I **really** wanted
to avoid going the java route where the observer receiving function just takes
in an ``Object`` and leaves it up to the handler to cast it into something usable. 
I personally find that choice to be super hacky.

Thankfully C++ provides a ``std::function`` type which allows for template parameters
and will type check at compile time.  The signal receiver type can then be a 
specialization of ``std::function`` in which the return type is always void, and 
accepts a variable number of input parameter types.  I called it *delegate*
(inspired by the c\# type) and defined it as:

{% highlight c++ %}
template <typename ...Args>
using delegate = std::function<void(Args...)>;
{% endhighlight %}

The nice thing about ``std::function`` is that it can accept any callable
object including lambdas and functors (callable objects).

### The signal

Now that the slot is done, the signal type is trivial.  We simply need
to maintain a list of slots, and expose an interface for registering new slots
and sending messages to them.

{% highlight c++ %}
template <typename ...Args>
class signal {
private:
    using fn_t = delegate<Args...>;
    std::vector<fn_t> observers;

public:
    void connect(fn_t f) {
        observers.push_back(f);
    }

    void operator ()(Args... a) {
        for (auto i: observers)
            i(a...);
    }
};
{% endhighlight %}

You can now embed this signal type inside of GUI components, pass it as an 
asynchronous callback, etc. without having to worry about any kind of boilerplate
or inheritance.  You also avoid having to perform any cast or type checking operations
inside the slot.
An example usage of this code in a GUI setting follows.


{% highlight c++ %}
#include "signal.h"
#include <string>
#include <iostream>
#include <functional>

struct button {
    qp::signal<std::string> update;

    void click() {
        update("clicked!");
    }
};

struct label {
    std::string text;
    void changeText(std::string s) {
        text = s;
        std::cout << s << std::endl;
    }
};

int main() {
    using namespace std::placeholders;

    label label1;
    label label2;

    button button1;
    button1
        .update
        .connect(std::bind(&label::changeText, std::ref(label1), _1));
    // or
    // button1.update.connect([&](std::string s) { label1.changeText(s); });
    button1
        .update
        .connect(std::bind(&label::changeText, std::ref(label2), _1));

    button1.click();
    return 0;
}
{% endhighlight %}

[Full Code](https://gist.github.com/Quinny/aa2ed2189a3c4209b50f)
