---
title: The Ruby Changes
description: "Changelog of the Ruby programming language: full, comprehensive, concise, well-structured, and open."
next: "/evolution.html"
permalink: "/index.html"
image: images/intro.png
---

## The Ruby Changes

This site is dedicated to history of [Ruby language](https://www.ruby-lang.org/) evolution. Basically, it is just the same information that each Ruby version's [NEWS](https://github.com/ruby/ruby/blob/master/NEWS.md) file contains, just in more readable and informative manner.

> <big>Latest version: <b><a href="3.3.html">3.3</a></b></big> ([3.2](3.2.html) − [3.1](3.1.html) − [3.0](3.0.html) − [2.7](2.7.html) − [2.6](2.6.html) −[2.5](2.5.html) − [2.4](2.4.html))<br/><br/>**[Ruby Evolution](evolution.html)**: bird-eye view on all significant changes 2.0−3.2, grouped by topic.

### Main goals

* **Full**: unlike most of "What's new in Ruby x.y?" blog posts, information here targets to cover all the `NEWS` file of current Ruby version;
* **Comprehensive**: unlike the `NEWS` file itself (and most of blog-posts, too), the site provides full context for each change:
  * Where and how it was discussed;
  * Related documentation at ruby-doc.org;
  * Code examples;
  * Reasoning for the change, if known.
* **Concise**: given two goals above, content still tries to stay short and focused, so the changes could be quickly navigated through;
* **Well-structured**: both regarding order/explanations of each particular change, and design of the site, it is intended to be easily and logically navigated.
* **Open**: the source of changelog is [available](https://github.com/rubyreferences/rubychanges) on the GitHub and is open for fixes and suggestions.

### Some things to know about the content

* Structure and grouping of the information, as well as the illustrative examples, are mostly decided by this site's [author](https://zverok.space). I am trying to make it as useful and logical as humanly possible, but I have my own opinions about what is important, and what is not, what is related and what is not.
  * Maybe "Highlights" section at the top of each version changelog is more subjective than the rest of the content, but it is totally optional, you can skip it.
* The site is dedicated to the **language**, not its **implementation(s)**, therefore at the moment it **does not** include the description of MRI implementation changes, optimizations and internals.
* ...and also some minor _behavior_ changes are excluded.
* I want to _eventually_ cover Ruby versions down to 1.8, or maybe even earlier, but it is currently work-in-progress. I started doing it at the wake of **[Ruby 2.6](2.6.html)**, and maintaining the changelog since.
* **UPD 2019-06-06:** **[Ruby 2.5](2.5.html)** is now covered too. Despite being 1.5 years old news, I believe it is still important to cover it in the same manner as the recent version was.
* **UPD 2019-10-14:** **[Ruby 2.4](2.4.html)** changelog added, and some other content changed. See [History](/History.html) for detail.
* **UPD 2019-12-27:** Newly released **[Ruby 2.7](2.7.html)** changelog added.
* **UPD 2020-12-25:** Newly released **[Ruby 3.0](3.0.html)** changelog added.
* **UPD 2022-01-05:** Newly released **[Ruby 3.1](3.1.html)** changelog added.
* **UPD 2022-06-09:** Newly released **[Ruby Evolution](evolution.html)** bird-eye view added.
* **UPD 2023-02-04:** Newly released **[Ruby 3.2](3.2.html)** changelog added.
* **UPD 2023-12-25:** Newly released **[Ruby 3.3](3.3.html)** changelog added.

_The source of the site can be found at [GitHub](https://github.com/rubyreferences/rubychanges). See also the [Contributing](Contributing.html) section._

## Blog posts about the changelog

Maintainer's posts on work on the changelogs:

* Deceber 2023: _Advent of Changelog_ (coming in a couple of days after 3.3's changelog)
* February 2023: [Participating in programming language's evolution during interesting times](https://zverok.space/blog/2023-02-07-changelog2023.html)
* June 2022: [Ruby language evolution on a large scale (as observed from Ukraine)](https://zverok.space/blog/2022-06-11-ruby-evolution.html)
* January 2022's write up:
  1. [What you can learn by merely writing a programming language changelog](https://zverok.space/blog/2022-01-06-changelog.html)
  2. [Following the programming language evolution, and taking it personally](https://zverok.space/blog/2022-01-13-it-evolves.html)
  3. [Programming language evolution: with all that, we are still flying](https://zverok.space/blog/2022-01-20-still-flying.html).

### Credits and licenses

* The source of information is NEWS files from Ruby repository.
* Book theme is initially borrowed from [mdBook](https://github.com/rust-lang-nursery/mdBook) project.
* The work in this repository (text, scripts and custom additions to design) is made by [Victor Shepelev](https://zverok.space) and should be considered **Public Domain**.
