# The Ruby Changes

This site is dedicated to history of [Ruby language](https://www.ruby-lang.org/) evolution. Basically, it is just the same information that each Ruby version's [NEWS](https://github.com/ruby/ruby/blob/master/NEWS.md) file contains, just in more readable and informative manner.

**See [The rendered version of the site](https://rubyreferences.github.io/rubychanges/)** for a description.

## Contributing

> Also duplicated on [Contributing](https://rubyreferences.github.io/rubychanges/Contributing.html) page of teh site.

[The repo](https://github.com/rubyreferences/rubychanges) gladly accepts contributions!

Things you need to know, as of now:

* The source is in `_src/<version>.md`;
* To "compile" the final Jekyll site, you need to run `rake` in the main folder, or separate tasks (visible with `rake -T`):
  * `bundle exec rake toc` (create TOC in `_data/book.yml`)
  * `bundle exec rake contents` (postprocesses `./_src/<version>.md`→`./<version>.md` adding some nicer formatting not available in pure Markdown);
* Now you can run `jekyll serve` to preview the site locally.

The main things to do, currently:

* Proofread existing content;
* Add previous versions of Ruby.

## Credits and licenses

* The source of information is NEWS files from Ruby repository.
* Book theme is initially borrowed from [mdBook](https://github.com/rust-lang-nursery/mdBook) project.
* The work in this repository (text, scripts and custom additions to design) is made by [Victor Shepelev](https://zverok.github.io) and should be considered **Public Domain**.
