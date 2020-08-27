---
title: Contributing
---

# Contributing

[The repo](https://github.com/rubyreferences/rubychanges) gladly accepts contributions! 

Things you need to know, as of now:

* The source is in `_src/<version>.md`;
* To "compile" the final Jekyll site, you need to run `rake` in the main folder, or separate tasks (visible with `rake -T`):
  * `rake toc` (create TOC in `_data/book.yml`)
  * `rake contents` (postprocesses `./_src/<version>.md`→`./<version>.md` adding some nicer formatting not available in pure Markdown);
* Now you can run `jekyll serve` to preview the site locally.

The main things to do, currently:

* Proofread existing content;
* Add previous versions of Ruby.
