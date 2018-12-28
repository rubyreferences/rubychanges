---
title: Contributing
---

# Contributing

The repo gladly accepts contributions!

Things you need to know, as of now:

* The source is in `_src/<version>.md` (2.6 only);
* To "compile" the final Jekyll site, you need to run first `_src/script/toc.rb` (create TOC in `_data/book.yml`), and then `_src/script/postprocess.rb` (creates `./2.6.md` with a bit more sophisticated rendering).

The main things to do, currently:

* Proofread existing content;
* Add previous versions of Ruby;
* Make rendering scripts less ad-hoc.