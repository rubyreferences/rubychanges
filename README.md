---
title: Introduction
next: "/2.6.html"
permalink: "/index.html"
---

## The Ruby Changes

[![Patreon](https://img.shields.io/badge/patreon-donate-blue.svg)](https://www.patreon.com/zverok)

This site is dedicated to history of [Ruby language](http://ruby-lang.org/) evolution. Basically, it is just the same information that each Ruby version's [NEWS](https://github.com/ruby/ruby/blob/trunk/NEWS) file contains, just in more readable and informative manner.

Main goals:

* **Full**: unlike most of "What's new in Ruby x.y?" blog posts, information here targets to cover all the `NEWS` file of current Ruby version;
* **Comprehensive**: unlike the `NEWS` file itself (and most of blog-posts, too), the site provides full context for each change:
  * Where and how it was discussed;
  * Related documentation at ruby-doc.org;
  * Code examples;
  * Reasoning for the change, if known.
* **Concise**: given two goals above, content still tries to stay short and focused, so the changes could be quickly navigated through;
* **Well-structured**: both regarding order/explanations of each particular change, and design of the site, it is intended to be easily and logically navigated.
* **Open**: the source of changelog is [available](https://github.com/rubyreferences/rubychanges) on the GitHub and is open for fixes and suggestions.

Some things to know about the content:

* Structure and grouping of the information, as well as the illustrative examples, are mostly decided by this site's [author](https://zverok.github.io). I am trying to make it as useful and logical as humanly possible, but I have my own opinions about what is important, and what is not, what is related and what is not.
  * Maybe "Highlights" section at the top of each version changelog is more subjective than the rest of the content, but it is totally optional, you can skip it.
* The site is dedicated to the **language**, not its **implementation(s)**, therefore at the moment it **does not** include the description of MRI implementation changes, optimizations and internals.
* ...and also some minor _behavior_ changes are excluded.
* I want to _eventually_ cover Ruby versions down to 1.8, or maybe even earlier, but it is currently work-in-progress, with the first priority of the recent release of **[Ruby 2.6](2.6.html)**, and then going down version by version in my free time.
* **UPD 2019-06-06:** **[Ruby 2.5](2.5.html)** is now covered too. Despite being 1.5 years old news, I believe it is still important to cover it in the same manner as the recent version was.
* **UPD 2019-10-14:** **[Ruby 2.4](2.4.html)** changelog added, and some other content changed. See [History](/History.html) for detail.

_The source of the site can be found at [GitHub](https://github.com/rubyreferences/rubychanges). See also [Contributing](/Contributing.html) section._

## Credits and licenses

* The source of information is NEWS files from Ruby repository.
* Book theme is initially borrowed from [mdBook](https://github.com/rust-lang-nursery/mdBook) project.
* The work in this repository (text, scripts and custom additions to design) is made by [Victor Shepelev](https://zverok.github.io) and should be considered **Public Domain**.