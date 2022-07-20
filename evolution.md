---
title: Ruby Evolution
prev: /
next: 3.1
description: A very brief list of new significant features that emerged in Ruby programming language since version 2.0 (2013).
image: images/evolution.png
---

# Ruby Evolution

**A very brief list of new significant features that emerged in Ruby programming language since version 2.0 (2013).**

It is intended as a "bird eye view" that might be of interest for Ruby novices and experts alike, as well as for curious users of other technologies.

It is part of a bigger [Ruby Changes](/) effort, which provides a detailed explanations and justifications on what happens to the language, version by version. The detailed changelog currently covers versions since 2.4, and the brief changelog links to more detailed explanations for those versions (links are under version numbers at the beginning of the list items).

The choice of important features, their grouping, and depth of comment provided are informal and somewhat subjective. The author of this list is focused on the changes of the language as a system of thinking and its syntax/semantics more than on a particular implementation.

As Ruby is highly object-oriented language, most of the changes can be associated with some of its core classes. Nevertheless, a new method in one of the core classes frequently changes the way code could be written, not just adds some small convenience.

**🇺🇦 🇺🇦 This work was started in mid-February, before the start of aggressive full-scale war Russia leads against Ukraine. I am finishing it after my daily volunteer work (delivering food through my district), why my homecity Kharkiv is still constantly bombed. Please care to read two of my appeals to Ruby community before proceeding: [first](https://zverok.space/blog/2022-03-03-WAR.html), [second](https://zverok.space/blog/2022-03-15-STILL-WAR.html).<br/><big>[The latest blog post](https://zverok.space/blog/2022-06-11-ruby-evolution.html)</big> dedicated to the reference creation also juxtaposes the evolution of the language with my personal history and history of my country.🇺🇦 🇺🇦**


## General changes[](#general-changes)

* <span class="ruby-version">**2.0**</span> **Refinements are introduced as experimental feature**. It is meant to be a hygienic replacement for contextual extending of modules and classes. The feature became stable in 2.1, but still has questionable mindshare, so the further enhancements to it [are covered in "deeper topics" section](#refinements). Example of refinements usage:
  ```ruby
  # Without refinements: Extending core object to make writing some statistics-heavy report easier:
  class Numeric
    def percent_of(other)
      self.fdiv(other) * 100
    end
  end
  # Usage:
  csv << [spent.percent_of(budget), debt.percent_of(budget), budget]
  # The problem is, Numeric#percent_of is now available in every other module, and depending on the
  # name and design, might cause problems in unrelated code

  # With refinements:
  module Stats
    refine Numeric do
      def percent_of(other)
        self.fdiv(other) * 100
      end
    end
  end

  # The "refined" methods are available only in the file that explicitly uses them
  using Stats
  csv << [spent.percent_of(budget), debt.percent_of(budget), budget]

  ```
* <span class="ruby-version">[2.6](2.6.md#non-ascii-constant-names)</span> Non-ASCII constant names allowed
* <span class="ruby-version">[2.7](2.7.md#safe-and-taint-concepts-are-deprecated-in-general)</span> "Safe" and "taint" concepts are deprecated in general
* <span class="ruby-version">[3.0](3.0.md#changes-in-class-variable-behavior)</span> Class variable behavior became stricter: top-level `@@variable` is prohibited, as well as overriding in descendant classes and included modules.
* <span class="ruby-version">[3.0](3.0.md#types)</span> **Type definitions concept is introduced.** The discussion of possible solutions for static or gradual typing and possible syntax of type declarations in Ruby code had been open for years. At 3.0, Ruby’s core team made their mind towards type declaration in _separate files_ and _separate tools_ to check types. Example of type definition syntax:
  ```ruby
  class Dog
    attr_reader name: String

    def initialize: (name: String) -> void

    def bark: (at: Person | Dog | nil) -> String
  end
  ```

<!--
* <span class="ruby-version">**2.0**</span> No warning for unused variables starting with `_`
* <span class="ruby-version">[2.5](2.5.md#top-level-constant-look-up-is-removed)</span> Top-level constant look-up is removed
* <span class="ruby-version">[3.1](3.1.md#multiple-assignment-evaluation-order-change)</span> Multiple assignment evaluation order change (—)
-->

## Expressions[](#expressions)

* <span class="ruby-version">**2.3**</span> **Safe navigation operator**:
  ```ruby
  s = 'test'
  s&.length # => 4
  s = nil
  s&.length # => nil, instead of NoMethodError
  ```
* <span class="ruby-version">[2.4](2.4.md#multiple-assignment-allowed-in-conditional-expression)</span> Multiple assignment allowed in conditional expression
* <span class="ruby-version">[2.4](2.4.md#toplevel-return)</span> Toplevel `return` to stop interpreting the file immediately; useful for cases like platform-specific classes, where instead of wrapping the whole file in `if SOMETHING_SUPPORTED...`, you can just `return unless SOMETHING_SUPPORTED` at the beginning.

### Pattern-matching[](#pattern-matching)

* <span class="ruby-version">[2.7](2.7.md#pattern-matching)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html"><code>Pattern-matching</code></a> introduced as an experimental feature** that allows to deeply unpack/check nested data structures:
  ```ruby
  case config
  in version: 'legacy', username:    # matches {version: 'legacy', username: anything} and puts value in `username`
    puts "Connect with user '#{username}'"
  in db: {user: } # matches {db: {user: anything}} and puts value in `user`
    puts "Connect with user '#{user}'"
  in String => username # matches when config is a String and puts it into `username`
    puts "Connect with user '#{username}'"
  else
    puts "Unrecognized structure of config"
  end
  ```
* <span class="ruby-version">[3.0](3.0.md#one-line-pattern-matching-with-)</span> `=>` pattern-matching expression introduced
  ```ruby
  {a: 1, b: 2} => {a:} # -- deconstructs and assigns to local variable `a`; fails if pattern not matched
  long.chain.of.computations => result # can also be used as a "rightward assignment"
  ```
* <span class="ruby-version">[3.0](3.0.md#in-as-a-truefalse-check)</span> `in` pattern-matching expression repurposed as a `true`/`false` check
 ```ruby
  if {a: 1, b: 2} in {a:} # just "check if match", returning true/false; also deconstructs
  # ...
  ```
* <span class="ruby-version">[3.0](3.0.md#find-pattern)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html#label-Patterns">Find pattern</a> is supported: `[*elements_before, <complicated pattern>, *elements_after]`
* <span class="ruby-version">[3.1](3.1.md#expressions-and-non-local-variables-allowed-in-pin-operator-)</span> Expressions and non-local variables <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/pattern_matching_rdoc.html#label-Variable+pinning">allowed in pin operator `^`</a>
* <span class="ruby-version">[3.1](3.1.md#parentheses-can-be-omitted-in-one-line-pattern-matching)</span> Parentheses can be omitted in one-line pattern matching:
  ```ruby
  {a: 1, b: 2} => a:
  ```

## `Kernel`[](#kernel)

`Kernel` is a module included in every object, providing most of the methods that look "top-level", like `puts`, `require`, `raise` and so on.

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-__dir__"><code>#__dir__</code></a>: absolute path to current source file
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-caller_locations"><code>#caller_locations</code></a> which returns an array of frame information objects, in a form of new class <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread/Backtrace/Location.html"><code>Thread::Backtrace::Location</code></a>
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-caller"><code>#caller</code></a> accepts second optional argument `n` which specify required caller size.
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Kernel.html#method-i-throw"><code>#throw</code></a> raises `UncaughtThrowError`, subclass of `ArgumentError` when there is no corresponding catch block, instead of `ArgumentError`.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Kernel.html#method-i-loop"><code>#loop</code></a>: when stopped by a `StopIteration` exception, returns what the enumerator has returned instead of `nil`
* <span class="ruby-version">[2.5](2.5.md#pp)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Kernel.html#method-i-pp"><code>#pp</code></a> debug printing method is available without `require 'pp'`
* <span class="ruby-version">[3.1](3.1.md#kernelload-module-as-a-second-argument)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Kernel.html#method-i-load"><code>#load</code></a> allows to pass module as a second argument, to load code inside module specified

<!--
* <span class="ruby-version">[3.0](3.0.md#kerneleval-changed-processing-of-__file__-and-__line__)</span> `#eval` changed processing of `__FILE__` and `__LINE__` (—)
-->


## `Object`[](#object)

`Object` is a class most other classes are inherited from (save for very special cases when the `BasicObject` is inherited). So the methods defined in `Object` are available in most of the objects.<br/><br/>_Unlike `Kernel`'s method described above, `Object`'s methods are public. E.g. every object has private `#puts` from `Kernel` that it can use inside its own methods, and every object has public `#inspect` from `Object`, that can be called by other objects._

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Object.html#method-i-respond_to-3F"><code>#respond_to?</code></a> against a protected method now returns `false` by default, can be overrided by `respond_to?(:foo, true)`.
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Object.html#method-i-respond_to_missing-3F"><code>#respond_to_missing?</code></a>, `#initialize_clone`, `#initialize_dup` became private.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Object.html#method-i-singleton_method"><code>#singleton_method</code></a>
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Object.html#method-i-itself"><code>#itself</code></a> introduced, just returning the object and making code like this easier:
  ```ruby
  array_of_objects.group_by(&:itself)
  ```
* <span class="ruby-version">[2.6](2.6.md#then-as-an-alias-for-yield_self)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.6.0/Object.html#method-i-then"><code>#then</code></a>** (initially introduced as <span class="ruby-version">[2.5](2.5.md#yield_self)</span> `#yield_self`) for chainable computation, akin to Elixir's `|>`:
  ```ruby
  [BASE_URL, path].join('/')
    .then { |url| open(url).read }
    .then { |body| JSON.parse(body, symbolyze_names: true) }
    .dig(:data, :items)
    .then { |items| File.write('response.yml', items.to_yaml) }
  ```

<!--
* <span class="ruby-version">**2.0**</span> `#inspect` does not call `#to_s` anymore (it could cause a weird effect if `#to_s` is redefined).
-->

## Modules and classes[](#modules-and-classes)

This section lists changes in how modules and classes are defined, as well as new/changed methods of core classes `Module` and `Class`. Note that most of module-level "keywords" we regularly use are actually instance methods of the `Module` class:

```ruby
class Foo
  attr_reader :bar # it is a method Module#attr_reader

  private # it is a method Module#private

  include Enumerable # it is a method Module#include

  def each # def is not a method, it is a real keyword!
    # ...
  end

  define_method(:test, &block) # but it is a method Module#define_method
end
```

* <span class="ruby-version">**2.0**</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepend"><code>#prepend</code></a> introduced**: like `#include`, but adds prepended module to the beginning of the ancestors chain (also  <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepended"><code>#prepended</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepend_features"><code>#prepend_features</code></a> hooks):
  ```ruby
  class A < Array
    # Only adds new methods the class doesn't define itself
    include Enumerable

    def map
      puts "mapping"
    end
  end

  class B < Array
    # Goes in front of the class itself in ancestors chain, can redefine its methods
    prepend Enumerable

    def map
      puts "mapping"
    end
  end

  p A.ancestors                  # [A, Array, Enumerable, ...]
  p A.new([1, 2, 3]).map(&:to_s) # prints "mapping", returns nil
  p B.ancestors                  # [Enumerable, B, Array, ...]
  p B.new([1, 2, 3]).map(&:to_s) # returns ["1", "2", "3"]
  ```
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-const_get"><code>#const_get</code></a> accepts a qualified constant string, e.g. `Object.const_get("Foo::Bar::Baz")`
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-ancestors"><code>#ancestors</code></a>
* <span class="ruby-version">**2.1**</span> The ancestors of a singleton class now include singleton classes,  in particular itself.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-singleton_class-3F"><code>#singleton_class?</code></a>
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-include"><code>#include</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-prepend"><code>#prepend</code></a> are now public methods, so one can do `AnyClass.include AnyModule` without resorting to `send(:include, ...)` (which people did anyway)
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Module.html#method-i-deprecate_constant"><code>#deprecate_constant</code></a>
* <span class="ruby-version">[2.5](2.5.md#module-methods-for-defining-methods-and-accessors-became-public)</span> methods for defining methods and accessors (like <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Module.html#method-i-attr_reader"><code>#attr_reader</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Module.html#method-i-define_method"><code>#define_method</code></a>) became public
* <span class="ruby-version">[2.6](2.6.md#modulemethod_defined-inherit-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Module.html#method-i-method_defined-3F"><code>#method_defined?</code></a>: `inherit` argument
* <span class="ruby-version">[2.7](2.7.md#const_source_location)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Module.html#method-i-const_source_location"><code>#const_source_location</code></a>** allows to query where some constant (including modules and classes) was first defined.
* <span class="ruby-version">[2.7](2.7.md#autoload-inherit-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Module.html#method-i-autoload-3F"><code>#autoload?</code></a>: `inherit` argument.
* <span class="ruby-version">[3.0](3.0.md#include-and-prepend-now-affects-modules-including-the-receiver)</span> `#include` and `#prepend` now affects modules that already include the receiver:
  ```ruby
  module MyEnumerableExtension
    def each2(&block)
      each_slice(2, &block)
    end
  end

  Enumerable.include MyEnumerableExtension

  (1..8).each2.to_a
  # Ruby 2.7: NoMethodError (undefined method `each2' for 1..8:Range) -- even though Range includes Enumerable
  # Ruby 3.0: [[1, 2], [3, 4], [5, 6], [7, 8]]
  ```
* <span class="ruby-version">[3.0](3.0.md#improved-method-visibility-declaration)</span> Changes in return values/accepted parameters of several methods, making code like `private attr_reader :a, :b, :c` work (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/Module.html#method-i-attr_reader"><code>#attr_reader</code></a> started to return arrays of symbols, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/Module.html#method-i-private"><code>#private</code></a> accepts arrays)
* <span class="ruby-version">[3.1](3.1.md#classsubclasses)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Class.html#method-i-subclasses"><code>Class#subclasses</code></a>
* <span class="ruby-version">[3.1](3.1.md#moduleprepend-behavior-change)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Module.html#method-i-prepend"><code>Module#prepend</code></a> behavior changed to take effect even if the same module is already included.
* <span class="ruby-version">[3.1](3.1.md#moduleprivate-public-protected-and-module_function-return-their-arguments)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Module.html#method-i-private"><code>#private</code></a> and other visibility methods return their arguments, to allow usage in macros like `memoize private def my_method...`

<!--
* <span class="ruby-version">**2.0**</span> `#define_method` accepts a UnboundMethod from a Module.
-->

## Methods[](#methods)

This section lists changes in how methods are defined and invoked, as well as new/changed methods of core classes `Method` and `UnboundMethod`. Note: some of the behavior of method definition APIs in context of containing modules is covered in the above [section about modules](#modules-and-classes).

* <span class="ruby-version">**2.0**</span> **Keyword arguments.** Before Ruby 2.0, keyword arguments could've been imitated to some extent with last hash argument without parenthises. In Ruby 2.0, proper keyword arguments were introduced. At first, they could only be optional (default value should've always been defined):
  ```ruby
  # before Ruby 2.0:
  def render(data, options = {})
    indent = options.fetch(:indent, 2)
    separator = options.fetch(:separator) # imitation of mandatory arg., will raise if not present
    # ...
  end

  # calling: looks like separate argument due to Ruby allowing to omit {}
  render(something, indent: 4, separator: "\n\n")

  # Ruby 2.0:
  def render(data, indent: 2, separator: nil)
    raise ArgumentError, "separator is not defined" if separator.nil? # mandatory arguments should still be imitated
  ```
  * <span class="ruby-version">**2.1**</span> **Required keyword arguments** introduced:
    ```ruby
    def render(data, separator:, indent: 2) # will raise if `separator:` argument is not passed
    ```
* <span class="ruby-version">**2.0**</span> top-level `define_method` which defines a global function.
* <span class="ruby-version">**2.1**</span> `def` now returns the symbol of its name instead of `nil`. Usable to use in class-level "macros" method:
  ```ruby
  # before:
  def foo
  end
  private :foo

  # after:
  private def foo # `private` will receive :foo that `def` returned
  end
  ```
  * <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-define_method"><code>Module#define_method</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Object.html#method-i-define_singleton_method"><code>Object#define_singleton_method</code></a> also return the symbols of the defined methods, not the methods/procs
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Method.html#method-i-curry"><code>Method#curry</code></a>:
  ```ruby
  writer = File.method(:write).curry(2).call('test.txt') # curry with 2 arguments, supply first of them
  # Now, the `writer` can be used as a 1-argument callable object:
  writer.call('content') # Invokes File.write('test.txt', 'content')
  ```
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Method.html#method-i-super_method"><code>Method#super_method</code></a>
* <span class="ruby-version">[2.5](2.5.md#method)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Method.html#method-i-3D-3D-3D"><code>Method#===</code></a>, allowing to use it in `grep` and `case`:
  ```ruby
  require 'prime'
  (1..50).grep(Prime.method(:prime?))
  #=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
  ```
* <span class="ruby-version">[2.7](2.7.md#selfprivate_method)</span> `self.<private_method>` <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/syntax/modules_and_classes_rdoc.html#label-Visibility">is allowed</a>
* <span class="ruby-version">[2.7](2.7.md#keyword-argument-related-changes)</span> **[Big Keyword Argument Separation](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/):** some incompatibilities were introduced by need, so the distinction of keyword arguments and hashes in method arguments was more clear, handling numerous irritating edge cases.
* <span class="ruby-version">[2.7](2.7.md#keyword-argument-related-changes)</span> Introduce argument forwarding with `method(...)` syntax. As after the keyword argument separation "delegate everything" syntax became more complicated (you need to use and pass `(*args, **kwargs)`, because just `*args` wouldn't always work), simplified syntax was introduced:
  ```ruby
  def wrap_log(...) # this is literal code that can be used now, not a placeholder for a demo
    puts "Logging at #{Time.now}"
    log.call(...)
  end

  wrap_log(:info, "Foo", context: some_context) # both positional and keyword args are passed successfully
  ```
* <span class="ruby-version">[2.7](2.7.md#better-methodinspect)</span> Better <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Method.html#method-i-inspect"><code>Method#inspect</code></a> with signature and source code location
* <span class="ruby-version">[2.7](2.7.md#unboundmethodbind_call)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/UnboundMethod.html#method-i-bind_call"><code>UnboundMethod#bind_call</code></a>
* <span class="ruby-version">[3.0](3.0.md#arguments-forwarding--supports-leading-arguments)</span> Arguments forwarding (`...`) <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Argument+Forwarding"><code>supports</code></a> leading arguments
* <span class="ruby-version">[3.0](3.0.md#endless-method-definition)</span> **"<a class="ruby-doc" href="https://docs.ruby-lang.org/en/master/syntax/methods_rdoc.html"><code>Endless</code></a>" (one-line) method definition**:
  ```ruby
  def square(n) = n**n
  ```
* <span class="ruby-version">[3.1](3.1.md#methodunboundmethod-public-private-protected)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Method.html#method-i-private-3F"><code>Method#private?</code></a>, `#protected?`, `#public?`, same are defined for `UnboundMethod`
  * _Note: it is possible the change would be reverted in 3.2_
* <span class="ruby-version">[3.1](3.1.md#values-in-hash-literals-and-keyword-arguments-can-be-omitted)</span> **Values in keyword arguments <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Keyword+Arguments">can be omitted</a>**:
  ```ruby
  x = 100
  p(x:) # same as p(x: x), prints: {:x => 100}
  ```
* <span class="ruby-version">[3.1](3.1.md#anonymous-block-argument)</span> Anonymous <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Block+Argument">block argument</a>:
  ```ruby
  def logged_open(filename, &)
    puts "Opening #{filename}..."
    File.open(filename, &)
  end
  ```

<!--
* <span class="ruby-version">[3.1](3.1.md#inside-endless-method-definitions-method-calls-without-parenthesis-are-allowed)</span> Inside "endless" method definitions, method calls without parenthesis are allowed (— (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html"><code>doc/syntax/methods.rdoc</code></a> doesn't mention new or old behavior.))
-->

## Procs, blocks and `Proc` class[](#procs-blocks-and-proc-class)

* <span class="ruby-version">**2.0**</span> removed `Proc#==` and `#eql?` so two procs are equal only when they are the same object.
* <span class="ruby-version">**2.2**</span> `ArgumentError` is no longer raised when lambda `Proc` is passed as a block, and the number of yielded arguments does not match the formal arguments of the lambda, if just an array is yielded and its length matches.
* <span class="ruby-version">[2.6](2.6.md#proc-composition)</span> **`Proc` composition with <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.6.0/Proc.html#method-i-3E-3E"><code>>></code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.6.0/Proc.html#method-i-3C-3C"><code><<</code></a>**:
  ```ruby
  PROCESSOR = proc { |str| '{' + str + '}' } >> :upcase.to_proc >> method(:puts)
  %w[test me please].map(&PROCESSOR)
  # prints
  #   {TEST}
  #   {ME}
  #   {PLEASE}
  ```
* <span class="ruby-version">[2.7](2.7.md#numbered-block-parameters)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.7.0/Proc.html#class-Proc-label-Numbered+parameters">Numbered block parameters</a>**:
  ```ruby
  [1, 2, 3].map { _1 * 100 } # => 100, 200, 300
  ```

<!--
* <span class="ruby-version">**2.1**</span> Returning from lambda proc now always exits from the Proc, not from the method where the lambda is created.  Returning from non-lambda proc exits from the method, same as the former behavior.
* <span class="ruby-version">[3.0](3.0.md#procs-with-rest-arguments-and-keywords-change-of-autosplatting-behavior)</span> Keyword arguments are now fully separated from positional arguments: Procs with "rest" arguments and keywords: change of autosplatting behavior (—)
* <span class="ruby-version">[3.0](3.0.md#symbolto_proc-reported-as-lambda)</span> Procs/lambdas: `Symbol#to_proc` reported as lambda (—)
* <span class="ruby-version">[3.0](3.0.md#kernellambda-warns-if-called-without-a-literal-block)</span> `Kernel#lambda` warns if called without a literal block (—)
* <span class="ruby-version">[3.0](3.0.md#proc-and-eql)</span> Procs/lambdas: `Proc#==` and `#eql?` (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Proc.html#method-i-3D-3D"><code>Proc#==</code></a>)
-->

## `Comparable`[](#comparable)

Included in many classes to implement comparison methods. Once class defines a method `#<=>` for object comparison (returning `-1`, `0`, `1`, or `nil`) and includes `Comparable`, methods like `==`, `<`, `<=` etc. are defined automatically. Changes in `Comparable` module affect most of comparable objects in Ruby, including core ones like numbers and strings.

* <span class="ruby-version">**2.3**</span> `#==` no longer rescues exceptions (so if owner class' `<=>` raises, the user will see original exception)
* <span class="ruby-version">[2.4](2.4.md#comparableclamp)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Comparable.html#method-i-clamp"><code>#clamp</code></a>**:
  ```ruby
  123.clamp(50, 100) # => 100
  23.clamp(50, 100) # => 50
  53.clamp(50, 100) # => 53
  ```
* <span class="ruby-version">[2.7](2.7.md#comparableclamp-with-range)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Comparable.html#method-i-clamp"><code>#clamp</code></a> supports `Range` argument**:
  ```ruby
  123.clamp(0..100)
  # one-sided clamp with endless/beginless ranges work too!
  -123.clamp(0..) #=> 0
  123.clamp(..100) #=> 100
  ```

## `Numeric`[](#numeric)

* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Fixnum.html#method-i-bit_length"><code>Fixnum#bit_length</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Bignum.html#method-i-bit_length"><code>Bignum#bit_length</code></a>
* <span class="ruby-version">**2.1**</span> **Added suffixes for integer and float literals: `r`, `i`, and `ri`**:
  ```ruby
  1/3r   # => (1/3), Rational
  2 + 5i # => (2 + 5i), Complex
  ```
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Float.html#method-i-next_float"><code>Float#next_float</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Float.html#method-i-prev_float"><code>#prev_float</code></a>
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Numeric.html#method-i-positive-3F"><code>Numeric#positive?</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Numeric.html#method-i-negative-3F"><code>#negative?</code></a>
* <span class="ruby-version">[2.4](2.4.md#fixnum-and-bignum-are-unified-into-integer)</span> **`Fixnum` and `Bignum` are unified into <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Integer.html"><code>Integer</code></a>**
* <span class="ruby-version">[2.4](2.4.md#numericfinite-and-infinite)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-infinite-3F"><code>Numeric#infinite?</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-finite-3F"><code>#finite?</code></a>
* <span class="ruby-version">[2.4](2.4.md#integerdigits)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Integer.html#method-i-digits"><code>Integer#digits</code></a>
* <span class="ruby-version">[2.4](2.4.md#ndigits-optional-argument-for-rounding-methods)</span> Rounding methods <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-ceil"><code>Numeric#ceil</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-floor"><code>Numeric#floor</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-truncate"><code>Numeric#truncate</code></a>: `ndigits` optional argument.
* <span class="ruby-version">[2.4](2.4.md#half-option-for-round-method)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-i-round"><code>Integer#round</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Float.html#method-i-round"><code>Float#round</code></a>: `half:` argument
* <span class="ruby-version">[2.5](2.5.md#pow-modulo-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-i-pow"><code>Integer#pow</code></a>: `modulo` argument
* <span class="ruby-version">[2.5](2.5.md#allbits-anybits-nobits)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F"><code>Integer#allbits?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F"><code>#anybits?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F"><code>#nobits?</code></a>
  ```ruby
  # classic way of checking some flags:
  (object.flags & FLAG_ADMIN) > 0
  # new way:
  object.flags.anybits?(FLAG_ADMIN)
  ```
* <span class="ruby-version">[2.5](2.5.md#sqrt)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Integer.html#method-c-sqrt"><code>Integer.sqrt</code></a>
* <span class="ruby-version">[2.7](2.7.md#integer-with-range)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Integer.html#method-i-5B-5D"><code>Integer#[]</code></a> supports range of bits
* <span class="ruby-version">[3.1](3.1.md#integertry_convert)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Integer.html#method-c-try_convert"><code>Integer.try_convert</code></a>

<!--
* <span class="ruby-version">**2.2**</span> `Math.log` now raises `Math::DomainError` instead of returning NaN if the  base is less than 0, and returns NaN instead of -infinity if both of two arguments are 0.
* <span class="ruby-version">**2.2**</span> `Math.atan2` now returns values like as expected by C99 if both two arguments are infinity.
* <span class="ruby-version">[2.7](2.7.md#complex)</span> `Complex#<=>` (<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Complex.html#method-i-3C-3D-3E"><code>Complex#<=></code></a>)
-->

## Strings, symbols, regexps, encodings[](#strings-symbols-regexps-encodings)

* <span class="ruby-version">**2.0**</span> **Big encoding cleanup**:
  * Default source encoding is changed to UTF-8 (was US-ASCII)
  * Iconv has been removed from standard library; core methods like <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-encode"><code>String#encode</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-force_encoding"><code>String#force_encoding</code></a> (introduced in 1.9) should be preferred
* <span class="ruby-version">**2.0**</span> **`%i` symbol array literals shortcut**:
  ```ruby
  %i[first_name last_name age] # => [:first_name, :last_name, :age]
  ```
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-b"><code>String#b</code></a> to set string encoding as ASCII-8BIT (aka "binary", raw bytes).
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-scrub"><code>String#scrub</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-scrub-21"><code>#scrub!</code></a> to verify and fix invalid byte sequence.
* <span class="ruby-version">**2.2**</span> Most symbols which are returned by <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-to_sym"><code>String#to_sym</code></a> are garbage collectable. _While it might be perceived as an implementation detail, it means also the change in language use: there is no need to avoid symbols where they are more expressive, even if there are a lot of them._
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalize"><code>String#unicode_normalize</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalize-21"><code>#unicode_normalize!</code></a>, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalized-3F"><code>#unicode_normalized?</code></a>
* <span class="ruby-version">**2.3**</span> **`<<~` HERE-document literal** (removing the leading spaces):
  ```ruby
  text = <<~HERE
          The text, indented for readability.
          No leading spaces please.
         HERE

  p text
  # => "The text, indented for readability.\nNo leading spaces please.\n"
  ```
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/String.html#method-c-new"><code>String.new</code></a> accepts keyword argument `encoding:`
* <span class="ruby-version">[2.4](2.4.md#unicode-case-conversions)</span> Case conversions (<a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-downcase"><code>String#downcase</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-upcase"><code>String#upcase</code></a>, and other related methods) fully support Unicode:
  ```ruby
  'Straße'.upcase # => 'STRASSE'
  'İzmir'.upcase(:turkic) # => İZMİR -- locale-specific case conversion
  ```
* <span class="ruby-version">[2.4](2.4.md#stringnewcapacity-size)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-c-new"><code>String::new</code></a>: `capacity:` argument to pre-allocate memory if it is known the string will grow
* <span class="ruby-version">[2.4](2.4.md#casecmp)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-casecmp-3F"><code>String#casecmp?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Symbol.html#method-i-casecmp-3F"><code>Symbol#casecmp?</code></a> as a more expressive version of `#casecmp` when boolean value is needed (`#casecmp` returns `-1`/`0`/`1`):
  ```ruby
  'FOO'.casecmp?('foo') # => true
  'Straße'.casecmp?('STRASSE') # => true, Unicode-aware
  ```
* <span class="ruby-version">[2.4](2.4.md#stringconcat-and-prepend-accept-multiple-arguments)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-concat"><code>String#concat</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-prepend"><code>#prepend</code></a> accept multiple arguments
* <span class="ruby-version">[2.4](2.4.md#stringunpack1)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-unpack1"><code>String#unpack1</code></a> as a shortcut to `"foo".unpack(...).first`
* <span class="ruby-version">[2.4](2.4.md#match-method)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match-3F"><code>Regexp#match?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/String.html#method-i-match-3F"><code>String#match?</code></a>, and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Symbol.html#method-i-match-3F"><code>Symbol#match?</code></a> for when it is only necessary to know "if it matches or not". Unlike `=~` and `#match`, the methds don't alocate `MatchData` instance, which might make the check more efficient.
* <span class="ruby-version">[2.4](2.4.md#matchdata-better-support-for-named-captures)</span> `MatchData`: better support for named captures: <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/MatchData.html#method-i-named_captures"><code>#named_captures</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/MatchData.html#method-i-values_at"><code>#values_at</code></a>
* <span class="ruby-version">[2.5](2.5.md#delete_prefix-delete_prefix-delete_suffix-delete_suffix)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-delete_prefix"><code>String#delete_prefix</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-delete_suffix"><code>#delete_suffix</code></a>
* <span class="ruby-version">[2.5](2.5.md#each_grapheme_cluster-and-grapheme_clusters)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-grapheme_clusters"><code>String#grapheme_clusters</code></a>and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-each_grapheme_cluster"><code>#each_grapheme_cluster</code></a>
* <span class="ruby-version">[2.5](2.5.md#undump)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-undump"><code>String#undump</code></a> deserialization method, symmetric to `#dump`
* <span class="ruby-version">[2.5](2.5.md#start_with-accepts-a-regexp)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/String.html#method-i-start_with-3F"><code>String#start_with?</code></a> accepts a regexp (but not `#end_with?`)
* <span class="ruby-version">[2.5](2.5.md#regexp-absence-operator)</span> `Regexp`: absence operator `(?~<pattern>)`: match everything except this particular pattern
* <span class="ruby-version">[2.6](2.6.md#stringsplit-with-block)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/String.html#method-i-split"><code>String#split</code></a> supports block:
  ```ruby
  "several\nlong\nlines".split("\n") { |part| puts part if part.start_with?('l') }
  # prints:
  #   long
  #   lines
  # => "several\nlong\nlines"
  ```
* <span class="ruby-version">[2.7](2.7.md#symbolstart_with-and-end_with)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Symbol.html#method-i-end_with-3F"><code>Symbol#end_with?</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Symbol.html#method-i-start_with-3F"><code>#start_with?</code></a> _as a part of making symbols as convenient as strings, while maintaining their separate meaning_
* <span class="ruby-version">[3.1](3.1.md#stringunpack-and-unpack1-offset-argument)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/String.html#method-i-unpack"><code>String#unpack</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/String.html#method-i-unpack1"><code>#unpack1</code></a> added `offset:` argument, to unpack data from the middle of a stream.
* <span class="ruby-version">[3.1](3.1.md#matchdatamatch-and-match_length)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/MatchData.html#method-i-match"><code>MatchData#match</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/MatchData.html#method-i-match_length"><code>MatchData#match_length</code></a>

<!--
* <span class="ruby-version">**2.0**</span> Switch Regexp engine to <a class="github" href="https://github.com/k-takata/Onigmo">Onigmo</a>
* <span class="ruby-version">**2.1**</span> `pack/unpack` (Array/String): `Q!` and `q!` directives for long long type if platform has the type.
* <span class="ruby-version">[2.5](2.5.md#casecmp-and-casecmp-return-nil-for-non-string-arguments)</span> `String#casecmp` and `#casecmp?` return `nil` for non-string arguments (<a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-casecmp"><code>String#casecmp</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-casecmp-3F"><code>String#casecmp?</code></a>)
* <span class="ruby-version">[2.5](2.5.md#string--optimized-for-memory-preserving)</span> `String#-@` optimized for memory preserving (<a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/String.html#method-i-2D-40"><code>String#-@</code></a>)
* <span class="ruby-version">[3.0](3.0.md#string-always-returning-string)</span> `String`: always returning `String` (—)
-->

## `Struct`[](#struct)

* <span class="ruby-version">[2.5](2.5.md#struct-with-keyword-arguments)</span> **Structs <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Struct.html#method-c-new"><code>initialized</code></a> by keywords**:
  ```ruby
  User = Struct.new(:name, :email, keyword_init: true)
  User.new(name: 'Matz', email: 'matz@ruby-lang.org')
  ```
* <span class="ruby-version">[3.1](3.1.md#warning-on-passing-keywords-to-a-non-keyword-initialized-struct)</span> Warning on passing keywords to a non-keyword-initialized struct
* <span class="ruby-version">[3.1](3.1.md#structclasskeyword_init)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Struct.html#method-c-keyword_init-3F"><code>Struct::keyword_init?</code></a>

## `Time`[](#time)

* <span class="ruby-version">[2.5](2.5.md#timeat-units)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Time.html#method-c-at"><code>Time.at</code></a> supports units
* <span class="ruby-version">[2.6](2.6.md#time-support-for-timezones)</span> **Support for <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Time.html#class-Time-label-Timezone+argument"><code>timezones</code></a>.** The timezone object should be provided by external library; expectation of its API matches the most popular <a class="github" href="https://github.com/tzinfo/tzinfo">tzinfo</a>:
  ```ruby
  require 'tzinfo'
  zone = TZInfo::Timezone.get('America/New_York')
  time = Time.new(2018, 6, 1, 0, 0, 0, zone)
  time.zone                 # => #<TZInfo::DataTimezone: America/New_York>
  time.strftime('%H:%M %Z') # => "00:00 EDT"
  time.utc_offset           # => -14400 = -4 hours
  time += 180 * 24*60*60    # + 180 days, summery->winter transition
  time.utc_offset           # => -18000, -5 hours -- daylight saving handled by timezone
  ```
* <span class="ruby-version">[2.7](2.7.md#floor-and-ceil)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Time.html#method-i-floor"><code>Time#floor</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Time.html#method-i-ceil"><code>#ceil</code></a>
* <span class="ruby-version">[3.1](3.1.md#in-parameter-for-constructing-time)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Time.html#method-c-new"><code>.new</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Time.html#method-c-at"><code>.at</code></a>, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Time.html#method-c-now"><code>.now</code></a>: `in: time_zone_or_offset` parameter for constructing time
  ```ruby
  Time.now(in: TZInfo::Timezone.get('America/New_York'))
  # => 2022-07-09 06:25:06.162617846 -0400
  Time.new(2022, 7, 1, 14, 30, in: '+05:00')
  # => 2022-07-01 14:30:00 +0500
  ```

<!--
* <span class="ruby-version">**2.0**</span> `Time#to_s` now returns US-ASCII encoding instead of BINARY.
* <span class="ruby-version">[2.7](2.7.md#inspect-includes-subseconds)</span> `Time#inspect` includes subseconds (<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Time.html#method-i-inspect"><code>Time#inspect</code></a>)
* <span class="ruby-version">[3.1](3.1.md#strftime-supports--0000-offset)</span> `#strftime` supports `-00:00` offset (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Time.html#method-i-strftime"><code>Time#strftime</code></a>)
-->

## Enumerables, collections, and iteration[](#enumerables-collections-and-iteration)

* <span class="ruby-version">**2.0**</span> A decision was made to make a clearer separation of methods returning enumerators to methods calculating the value and returning array immediately, namely:
  * <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-lines"><code>String#lines</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-chars"><code>#chars</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-codepoints"><code>#codepoints</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-bytes"><code>#bytes</code></a> now return arrays instead of an enumerators (methods for returning enumerators are <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-each_line"><code>#each_line</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-each_char"><code>#each_char</code></a> and so on).
  * <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-lines"><code>IO#lines</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-bytes"><code>#bytes</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-chars"><code>#chars</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-codepoints"><code>#codepoints</code></a> are deprecated in favor of <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-each_line"><code>#each_line</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-each_byte"><code>#each_byte</code></a> and so on.
* <span class="ruby-version">**2.0**</span> Binary search introduced in core with <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Range.html#method-i-bsearch"><code>Range#bsearch</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-bsearch"><code>Array#bsearch</code></a>.
* <span class="ruby-version">**2.3**</span> **`#dig` introduced** (in <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Array.html#method-i-dig"><code>Array</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-dig"><code>Hash</code></a>, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Struct.html#method-i-dig"><code>Struct</code></a>) for atomic nested data navigation:
  ```ruby
  data = {
    status: 200
    body: {users: [
      {id: 1, name: 'Victor'},
      {id: 2, name: 'Yuki'},
    ]}
  }
  data.dig(:body, :users, 1, :name) #=> 'Yuki'
  ```

### Numeric iteration[](#numeric-iteration)

* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Numeric.html#method-i-step"><code>Numeric#step</code></a> allows the limit argument to be omitted, producing `Enumerator`. Keyword arguments `to` and `by` are introduced for ease of use:
  ```ruby
  1.step(by: 5)         # => #<Enumerator: 1:step({:by=>5})>
  1.step(by: 5).take(3) #=> [1, 6, 11]
  ```
* <span class="ruby-version">[2.6](2.6.md#enumeratorarithmeticsequence)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Enumerator/ArithmeticSequence.html"><code>Enumerator::ArithmeticSequence</code></a> is introduced** as a type returned by <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Range.html#method-i-step"><code>Range#step</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Numeric.html#method-i-step"><code>Numeric#step</code></a>:
  ```ruby
  1.step(by: 5)     # => (1.step(by: 5)) -- more expressive representation than above
  (1..200).step(3)  # => ((1..200).step(3))
  # It is also more powerful than generic Enumerator, as there is more knowledge about
  # the nature of the sequence:
  (1..200).step(3).last(2) # => [196, 199]
  ```
* <span class="ruby-version">[2.6](2.6.md#range-alias)</span> `Range#%` alias for `Range#step` for expressiveness: `(1..10) % 2` produces `ArithmeticSequence` with meaning "from 1 to 10, each second element"; since Ruby 3.0, this can be used to slicing arrays:
  ```ruby
  (0..) % 3
  letters = ('a'..'z').to_a
  letters[(0..) % 3]
  #=> ["a", "d", "g", "j", "m", "p", "s", "v", "y"]
  ```

### `Enumerable` and `Enumerator`[](#enumerable-and-enumerator)

* <span class="ruby-version">**2.0**</span> **The concept of lazy enumerator introduced with <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Enumerable.html#method-i-lazy"><code>Enumerable#lazy</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Enumerator/Lazy.html"><code>Enumerator::Lazy</code></a>**:
  ```ruby
  # If source is very large or has side effects like network reading, the following code will
  # first read it all, then produce intermediate array on each step
  source.select { some_condition }.map { some_transformation }.first(3)

  # while this code will just stack together operations, and then produce items one by one, till
  # the first 3 results are received:
  #      vvvv
  source.lazy.select { some_condition }.map { some_transformation }.first(3)
  ```
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Enumerator.html#method-i-size"><code>Enumerator#size</code></a> for on-demand size calculation when possible. The code that creates Enumerator, might pass `size` argument to <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Enumerator.html#method-c-new"><code>Enumerator.new</code></a> (value or a callable object) if it can calculate the amount of objects to enumerate.
  * <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Range.html#method-i-size"><code>Range#size</code></a> added, returning non-`nil` value only for integer ranges
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-slice_after"><code>Enumerable#slice_after</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-slice_when"><code>#slice_when</code></a>
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-min"><code>Enumerable#min</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-min_by"><code>#min_by</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-max"><code>#max</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-max"><code>#max_by</code></a> support optional argument to return multiple elements:
  ```ruby
  [1, 6, 7, 2.3, -100].min(3) # => [-100, 1, 2.3]
  ```
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Enumerable.html#method-i-grep_v"><code>Enumerable#grep_v</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Enumerable.html#method-i-chunk_while"><code>#chunk_while</code></a>
* <span class="ruby-version">[2.4](2.4.md#sum)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-sum"><code>Enumerable#sum</code></a> as a generalized shortcut for `reduce(:+)`; might be redefined in descendants (like `Array`) for efficiency.
* <span class="ruby-version">[2.4](2.4.md#uniq)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-uniq"><code>Enumerable#uniq</code></a>
* <span class="ruby-version">[2.5](2.5.md#enumerableany-all-none-and-one-accept-patterns)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-all-3F"><code>Enumerable#all?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-any-3F"><code>#any?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-none-3F"><code>#none?</code></a>, and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-one-3F"><code>#one?</code></a> accept patterns (any objects defining `#===`):
  ```ruby
  objects.all?(Numeric)
  ages.any?(18..60)
  strings.none?(/admin/i)
  ```
* <span class="ruby-version">[2.6](2.6.md#enumerator-chaining)</span> **`Enumerator` chaining with <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Enumerator.html#method-i-2B"><code>Enumerator#+</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Enumerable.html#method-i-chain"><code>Enumerable#chain</code></a>, producing <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Enumerator/Chain.html"><code>Enumerator::Chain</code></a>**:
  ```ruby
  # Take data from several sources, abstracted into enumerator, fetching it on demand
  sources = URLS.lazy.map { |url| open(url).read }
    .chain(LOCAL_FILES.lazy.map { |path| File.read(path) })

  # ...then uniformly search several sources (lazy-loading them) for some value
  sources.detect { |body| body.include?('Ruby 2.6') }
  ```
* <span class="ruby-version">[2.6](2.6.md#filterfilter)</span> `Enumerable#filter`/`#filter!` as alias for `#select`/`#select!` (as more familiar for users coming from other languages)
* <span class="ruby-version">[2.7](2.7.md#enumeratorproduce)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.7.0/Enumerator.html#method-c-produce"><code>Enumerator.produce</code></a> to convert loops into enumerators**:
  ```ruby
  # Classic loop:
  date = Date.today
  date += 1 until date.monday?
  # With Enumerator.produce:
  Enumerator.produce(Date.today) { |date| date + 1 }.find(&:monday?)
  ```
* <span class="ruby-version">[2.7](2.7.md#enumerablefilter_map)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Enumerable.html#method-i-filter_map"><code>Enumerable#filter_map</code></a>
* <span class="ruby-version">[2.7](2.7.md#enumerabletally)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Enumerable.html#method-i-tally"><code>Enumerable#tally</code></a> method to count stats (hash of `{object => number of occurrences in the enumerable}`)
  * <span class="ruby-version">[3.1](3.1.md#enumerabletally-now-accepts-an-optional-hash-to-count)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-tally"><code>#tally</code></a> accepts an optional hash to append results to
* <span class="ruby-version">[2.7](2.7.md#enumeratorlazyeager)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Enumerator/Lazy.html#method-i-eager"><code>Enumerator::Lazy#eager</code></a>
* <span class="ruby-version">[2.7](2.7.md#enumeratoryielderto_proc)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Enumerator/Yielder.html#method-i-to_proc"><code>Enumerator::Yielder#to_proc</code></a>
* <span class="ruby-version">[3.1](3.1.md#enumerablecompact-and-enumeratorlazycompact)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-compact"><code>Enumerable#compact</code></a>

<!--
* <span class="ruby-version">**2.3**</span> `#chunk` and `#slice_before` no longer takes the `initial_state` argument
* <span class="ruby-version">[2.4](2.4.md#enumerablechunk-without-a-block-returns-an-enumerator)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-chunk"><code>Enumerable#chunk</code></a> without a block returns an `Enumerator`
* <span class="ruby-version">[3.1](3.1.md#enumerableeach_cons-and-each_slice-return-a-receiver)</span> `#each_cons` and `#each_slice` return a receiver (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-each_cons"><code>Enumerable#each_cons</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-each_slice"><code>Enumerable#each_slice</code></a>)
* <span class="ruby-version">[3.1](3.1.md#enumerablecompact-and-enumeratorlazycompact)</span> `Enumerator::Lazy#compact` (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-compact"><code>Enumerable#compact</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Enumerator/Lazy.html#method-i-compact"><code>Enumerator::Lazy#compact</code></a>)
-->

### `Range`[](#range)

* <span class="ruby-version">[2.6](2.6.md#endless-range-1)</span> **Endless range: `(1..)`**
* <span class="ruby-version">[2.6](2.6.md#range-uses-cover-instead-of-include)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.6.0/Range.html#method-i-3D-3D-3D"><code>#===</code></a> uses `#cover?` instead of `#include?` which means that ranges can be used in `case` and `grep` for any types, just checking if the value is between range ends:
  ```ruby
  case DateTime.now
  when Date.new(2022)..Date.new(2023)
    # wouldn't match in Ruby 2.5, would match in Ruby 2.6
  ```
* <span class="ruby-version">[2.6](2.6.md#rangecover-accepts-range-argument)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.6.0/Range.html#method-i-cover-3F"><code>#cover?</code></a> accepts range argument
* <span class="ruby-version">[2.7](2.7.md#beginless-range)</span> **Beginless range: `(...100)`**

<!--
* <span class="ruby-version">[2.7](2.7.md#for-string)</span> `#===` for `String` (<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Range.html#method-i-3D-3D-3D"><code>Range#===</code></a>)
* <span class="ruby-version">[2.7](2.7.md#minmax-implementation-change)</span> `#minmax` implementation change (<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Range.html#method-i-minmax"><code>Range#minmax</code></a>)
-->

### `Array`[](#array)

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-shuffle"><code>#shuffle</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-sample"><code>#sample</code></a>: `random:` optional parameter that accepts random number generator, will be called with `max` argument.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Array.html#method-i-bsearch_index"><code>#bsearch_index</code></a>
* <span class="ruby-version">[2.4](2.4.md#arrayconcat-takes-multiple-arguments)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Array.html#method-i-concat"><code>#concat</code></a> takes multiple arguments
* <span class="ruby-version">[2.4](2.4.md#arraypackbuffer)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Array.html#method-i-pack"><code>#pack</code></a>: `buffer:` keyword argument to provide target
* <span class="ruby-version">[2.5](2.5.md#arrayappend-and-prepend)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Array.html#method-i-append"><code>#append</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Array.html#method-i-prepend"><code>#prepend</code></a>
* <span class="ruby-version">[2.6](2.6.md#arrayunion-and-arraydifference)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Array.html#method-i-union"><code>#union</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Array.html#method-i-difference"><code>#difference</code></a>
* <span class="ruby-version">[2.7](2.7.md#arrayintersection)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Array.html#method-i-intersection"><code>#intersection</code></a>
* <span class="ruby-version">[3.1](3.1.md#arrayintersect)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Array.html#method-i-intersect-3F"><code>#intersect?</code></a>

<!--
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-values_at"><code>#values_at</code></a> with Range argument returns `nil` for out-of-range indices
* <span class="ruby-version">[2.4](2.4.md#arraymax-and-min)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Array.html#method-i-max"><code>#max</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Array.html#method-i-min"><code>#min</code></a>
* <span class="ruby-version">[3.0](3.0.md#array-always-returning-array)</span> Always returning `Array` (—)
* <span class="ruby-version">[3.0](3.0.md#array-slicing-with-enumeratorarithmeticsequence)</span> Slicing with `Enumerator::ArithmeticSequence` (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Array.html#method-i-5B-5D"><code>Array#[]</code></a>)
-->

### `Hash`[](#hash)

* <span class="ruby-version">**2.0**</span> **Introduced convention of `#to_h` method** for explicit conversion to hashes, and added it to `Hash`, `nil`, and `Struct`;
  * <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Array.html#method-i-to_h"><code>Array#to_h</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Enumerable.html#method-i-to_h"><code>Enumerable#to_h</code></a> were added.
  * <span class="ruby-version">[2.6](2.6.md#to_h-with-a-block)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Enumerable.html#method-i-to_h"><code>#to_h</code></a> accepts a block to define conversion logic:
  ```ruby
  users.to_h { |u| [u.name, u.admin?] } # => {"John" => false, "Jane" => true, "Josh" => false}
  ```
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-Hash"><code>Kernel#Hash</code></a>, invoking argument's `#to_hash` implicit conversion method, if it has one.
* <span class="ruby-version">**2.2**</span> Change overriding policy for duplicated key: `{**hash1, **hash2}` contains values of `hash2` for duplicated keys.
* <span class="ruby-version">**2.2**</span> Hash literal: Symbol key followed by a colon can be quoted, allowing code like `{"data-key": value}` or `{"#{prefix}_data": value}`.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-fetch_values"><code>#fetch_values</code></a>: a multi-key version of `#fetch`
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3C"><code>#<</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3E"><code>#></code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3C-3D"><code>#<=</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3E-3D"><code>#>=</code></a> to check for inclusion of one hash in another.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-to_proc"><code>#to_proc</code></a>:
  ```ruby
  ATTRS = {first_name: 'John', last_name: 'Doe', gender: 'Male', age: 27}

  %i[first_name age].map(&ATTRS) # => ['John', 27]
  ```
* <span class="ruby-version">[2.4](2.4.md#hashcompact-and-compact)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Hash.html#method-i-compact"><code>#compact</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Hash.html#method-i-compact-21"><code>#compact!</code></a> to drop `nil` values
* <span class="ruby-version">[2.4](2.4.md#hashtransform_values-and-transform_values)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Hash.html#method-i-transform_values"><code>#transform_values</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Hash.html#method-i-transform_values-21"><code>#transform_values!</code></a>
* <span class="ruby-version">[2.5](2.5.md#hashtransform_keys-and-transform_keys)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Hash.html#method-i-transform_keys"><code>#transform_keys</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Hash.html#method-i-transform_keys-21"><code>#transform_keys!</code></a>
* <span class="ruby-version">[2.5](2.5.md#hashslice)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Hash.html#method-i-slice"><code>#slice</code></a>
* <span class="ruby-version">[2.6](2.6.md#hashmerge-with-multiple-arguments)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Hash.html#method-i-merge"><code>#merge</code></a> supports multiple arguments
* <span class="ruby-version">[3.0](3.0.md#hashexcept)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Hash.html#method-i-except"><code>#except</code></a>
* <span class="ruby-version">[3.0](3.0.md#hashtransform_keys-argument-for-key-renaming)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Hash.html#method-i-transform_keys"><code>#transform_keys</code></a>: argument for key renaming
  ```ruby
  {first: 'John', last: 'Doe'}.transform_keys(first: :first_name, last: :last_name)
  #=> {:first_name => 'John', :last_name => 'Doe'}
  ```
* <span class="ruby-version">[3.1](3.1.md#values-in-hash-literals-and-keyword-arguments-can-be-omitted)</span> **Values in Hash literals <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals">can be omitted</a>**:
  ```ruby
  x = 100
  y = 200
  {x:, y:}
  # => {x: 100, y: 200}, same as {x: x, y: y}
  ```

<!--
* <span class="ruby-version">[3.0](3.0.md#hasheach-consistently-yields-a-2-element-array-to-lambdas)</span> `#each` consistently yields a 2-element array to lambdas (—)
-->

### `Set`[](#set)

`Set` was a part of the standard library, but since Ruby 3.2 it will become part of Ruby core. A more efficient implementation (currently `Set` is implemented in Ruby, and stores data in `Hash` inside), and a separate set literal is up for discussion. That's why we list `Set`'s changes briefly here.

* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Set.html#method-i-intersect-3F"><code>#intersect?</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Set.html#method-i-disjoint-3F"><code>#disjoint?</code></a>
* <span class="ruby-version">**2.4**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.4.0/Set.html#method-i-compare_by_identity"><code>#compare_by_identity</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.4.0/Set.html#method-i-compare_by_identity-3F"><code>#compare_by_identity?</code></a>
* <span class="ruby-version">**2.5**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Set.html#method-i-3D-3D-3D"><code>#===</code></a> as alias to `#include?`, so `Set` can be used in `grep` and `case`:
  ```ruby
  file_list.grep(Set['README.md', 'License.txt']) # find an item that matches any of sets elements
  ```
* <span class="ruby-version">**2.5**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Set.html#method-i-reset"><code>#reset</code></a>
* <span class="ruby-version">**3.0**</span> `SortedSet` (that was a part of `set` standard library before) has been removed for dependency and performance reasons (it silently depended upon `rbtree` gem).
* <span class="ruby-version">**3.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/Set.html#method-i-join"><code>#join</code></a> is added as a shorthand for `.to_a.join`.
* <span class="ruby-version">**3.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0/Set.html#method-i-3C-3D-3E"><code>#<=></code></a> generic comparison operator (separate operators like `#<` or `#>` have been worked in previous versions, too)

<!--
* <span class="ruby-version">**2.5**</span> `#to_s` as alias to `#inspect`
-->

### Other collections[](#other-collections)

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/ObjectSpace/WeakMap.html"><code>ObjectSpace::WeakMap</code></a> introduced
* <span class="ruby-version">**2.3**</span> `Thread::Queue#close` is added to notice a termination
* <span class="ruby-version">[2.7](2.7.md#objectspaceweakmap-now-accepts-non-gc-able-objects)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/ObjectSpace/WeakMap.html#method-i-5B-5D-3D"><code>ObjectSpace::WeakMap#[]=</code></a> now accepts non-GC-able objects
* <span class="ruby-version">[3.1](3.1.md#threadqueueinitialize-initial-values-can-be-passed-to-initializer)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Thread/Queue.html#method-c-new"><code>Thread::Queue.new</code></a> allows initial queue content to be passed

## Filesystem and IO[](#filesystem-and-io)

* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-seek"><code>IO#seek</code></a> improvements: supports `SEEK_DATA` and `SEEK_HOLE`, and symbolic parameters (`:CUR`, `:END`, `:SET`, `:DATA`, `:HOLE`) for 2nd argument.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-read_nonblock"><code>IO#read_nonblock</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-write_nonblock"><code>#write_nonblock</code></a> accepts optional `exception: false` to return symbols
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Dir.html#method-i-fileno"><code>Dir#fileno</code></a>
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/File.html#method-c-birthtime"><code>File.birthtime</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/File.html#method-i-birthtime"><code>#birthtime</code></a>, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/File/Stat.html#method-i-birthtime"><code>File::Stat#birthtime</code></a>
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/File.html#method-c-mkfifo"><code>File.mkfifo</code></a>
* <span class="ruby-version">**2.3**</span> New <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/File/File/Constants.html"><code>flags/constants</code></a> for IO opening: `File::TMPFILE` (open anonymous temp file) and `File::SHARE_DELETE` (open file that is allowed to delete)
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/IO.html#method-c-new"><code>IO.new</code></a>: new keyword argument `flags:`
* <span class="ruby-version">[2.4](2.4.md#chomp-option-for-string-splitting)</span> `chomp:` option for string splitting:
  ```ruby
  File.readlines("test.txt") # => ["foo\n", "bar\n", "baz\n"]
  File.readlines("test.txt", chomp: true) # => ["foo", "bar", "baz"]
  ```
* <span class="ruby-version">[2.4](2.4.md#empty-method-for-filesystem-objects)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Dir.html#method-c-empty-3F"><code>Dir#empty?</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/File.html#method-c-empty-3F"><code>File#empty?</code></a>, and <a class="ruby-doc" href="https://ruby-doc.org/stdlib-2.4.0/libdoc/pathname/rdoc/Pathname.html#method-i-empty-3F"><code>Pathname#empty?</code></a>
* <span class="ruby-version">[2.5](2.5.md#iopread-and-pwrite)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/IO.html#method-i-pread"><code>IO#pread</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/IO.html#method-i-pwrite"><code>IO#pwrite</code></a>
* <span class="ruby-version">[2.5](2.5.md#iowrite-accepts-multiple-arguments)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/IO.html#method-i-write"><code>IO#write</code></a> accepts multiple arguments
* <span class="ruby-version">[2.5](2.5.md#fileopen-better-supports-newline-option)</span> `File.open` better supports `newline:` option
* <span class="ruby-version">[2.5](2.5.md#filelutime)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/File.html#method-c-lutime"><code>File.lutime</code></a>
* <span class="ruby-version">[2.5](2.5.md#dirchildren-and-each_child)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Dir.html#method-c-children"><code>Dir.children</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Dir.html#method-c-each_child"><code>.each_child</code></a>
  * <span class="ruby-version">[2.6](2.6.md#direach_child-and-dirchildren)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Dir.html#method-i-children"><code>#children</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Dir.html#method-i-each_child"><code>#each_child</code></a> (instance method counterparts)
* <span class="ruby-version">[2.5](2.5.md#dirglob-base-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Dir.html#method-c-glob"><code>Dir.glob</code></a>: `base:` argument allows to provide a directory to look into instead of constructing a glob string including it.
* <span class="ruby-version">[2.6](2.6.md#io-open-mode-x)</span> New <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/IO.html#method-c-new-label-IO+Open+Mode">IO open mode</a> `'x'`: combined with `'w'` (open for writing), requests that file didn't exist before opening.
* <span class="ruby-version">[2.7](2.7.md#ioset_encoding_by_bom)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/IO.html#method-i-set_encoding_by_bom"><code>IO#set_encoding_by_bom</code></a>
* <span class="ruby-version">[3.1](3.1.md#filedirname-optional-level-to-go-up-the-directory-tree)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/File.html#method-c-dirname"><code>File.dirname</code></a>: optional `level` to go up the directory tree
* <span class="ruby-version">[3.1](3.1.md#iobuffer)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/IO/Buffer.html"><code>IO::Buffer</code></a> low-level class introduced**

<!--
* <span class="ruby-version">**2.0**</span> `File.fnmatch?` now expands braces in the pattern if File::FNM_EXTGLOB option is given.
* <span class="ruby-version">**2.0**</span> `ARGF#codepoints` and `#each_codepoint`
* <span class="ruby-version">**2.2**</span> `IO#read_nonblock` and `#write_nonblock` for pipes on Windows are supported.
* <span class="ruby-version">**2.3**</span> `ARGF.read_nonblock` supports `exception: false` like IO#read_nonblock.
* <span class="ruby-version">[2.5](2.5.md#filepath-raises-when-opened-with-fileconstantstmpfile-option)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/File.html#method-c-path"><code>File#path</code></a> raises when opened with `File::Constants::TMPFILE` option.
* <span class="ruby-version">[2.7](2.7.md#dirglob-and-dir-not-allow-0-separated-patterns)</span> `Dir.glob` and `Dir.[]` not allow `\0`-separated patterns (<a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Dir.html#method-c-glob"><code>Dir.glob</code></a>)
* <span class="ruby-version">[2.7](2.7.md#fileextname-returns-a--string-at-a-name-ending-with-a-dot)</span> `File.extname` returns a `"."` string at a name ending with a dot. ([File.extname](https://bugs.ruby-lang.org/issues/15267))
* <span class="ruby-version">[3.0](3.0.md#dirglob-and-dir-result-sorting)</span> `Dir.glob` and `Dir.[]` result sorting (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Dir.html#method-c-glob"><code>Dir.glob</code></a>)
-->

## Exceptions[](#exceptions)

This section covers exception raising/handling behavior changes, as well as changes in particular core exception classes.

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/LoadError.html"><code>LoadError#path</code></a> method to return the file name that could not be loaded.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Exception.html#method-i-cause"><code>Exception#cause</code></a> provides the previous exception which has been caught at where raising the new exception.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/NameError.html#method-i-receiver"><code>NameError#receiver</code></a> stores an object in context of which the error have happened.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/NameError.html"><code>NameError</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/NoMethodError.html"><code>NoMethodError</code></a> suggest possible fixes with <a class="github" href="https://github.com/ruby/did_you_mean">did_you_mean</a> gem:
  ```ruby
  'test'.szie
  # NoMethodError: undefined method `szie' for "test":String
  # Did you mean?  size
  ```
* <span class="ruby-version">[2.5](2.5.md#rescueelseensure-are-allowed-inside-blocks)</span> **`rescue`/`else`/`ensure` are allowed inside blocks**:
  ```ruby
  # before Ruby 2.5:
  %w[1 - 3].map do |num|
    begin
      Integer(num)
    rescue
      'N/A'
    end
  end

  # Ruby 2.5+:
  %w[1 - 3].map do |num|
    Integer(num)
  rescue
    'N/A'
  end
  ```
* <span class="ruby-version">[2.5](2.5.md#exceptionfull_message)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Exception.html#method-i-full_message"><code>Exception#full_message</code></a>
* <span class="ruby-version">[2.5](2.5.md#keyerrorreceiver-and-key)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/KeyError.html"><code>KeyError</code></a>: `#receiver` and `#key` methods
* <span class="ruby-version">[2.5](2.5.md#new-class-frozenerror)</span> New class: <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/FrozenError.html"><code>FrozenError</code></a>
* <span class="ruby-version">[2.5](2.5.md#dont-hide-coercion-errors)</span> Don't hide coercion errors in `Numeric` and `Range` operations: raise original exception and not "can't be coerced" or "bad value for range"
* <span class="ruby-version">[2.6](2.6.md#else-in-exception-handling-context)</span> `else` in exception-handling context without any `rescue` is prohibited.
* <span class="ruby-version">[2.6](2.6.md#numeric-methods-have-exception-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Kernel.html#method-i-Integer"><code>#Integer()</code></a> and other similar conversion methods now have optional argument `exception: true/false`, defining whether to raise error on input that can't be converted or just return `nil`
* <span class="ruby-version">[2.6](2.6.md#system-has-exception-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Kernel.html#method-i-system"><code>#system</code></a>: optional argument `exception: true/false`
* <span class="ruby-version">[2.6](2.6.md#new-arguments-receiver-and-key)</span> New arguments: `receiver:` for <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/NameError.html#method-c-new"><code>NameError::new</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/NoMethodError.html#method-c-new"><code>NoMethodError::new</code></a>; `key:`  for <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/KeyError.html#method-c-new"><code>KeyError::new</code></a>. It allows user code to construct errors with the same level of detail the language can.
* <span class="ruby-version">[2.6](2.6.md#exceptionfull_message-options)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Exception.html#method-i-full_message"><code>Exception#full_message</code></a>: formatting options `highlight:` and `order:` added
* <span class="ruby-version">[2.7](2.7.md#frozenerror-receiver-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/FrozenError.html#method-c-new"><code>FrozenError#new</code></a>: receiver argument
* <span class="ruby-version">[3.1](3.1.md#threadbacktracelimit)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Thread/Backtrace.html#method-c-limit"><code>Thread::Backtrace.limit</code></a> reader to get the maximum backtrace size set with `--backtrace-limit` command-line option

<!--
* <span class="ruby-version">[2.5](2.5.md#backtrace-and-error-message-in-reverse-order)</span> Backtrace and error message are (experimentally) displayed in a reverse order.
* <span class="ruby-version">[2.6](2.6.md#exception-output-tweaking)</span> Exception output tweaking (—)
* <span class="ruby-version">[3.0](3.0.md#exception-output-order-is-changed----again)</span> Exception output order is changed -- again (—)
-->

### Warnings[](#warnings)

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-warn"><code>Kernel#warn</code></a> accepts multiple args in like `#puts`.
* <span class="ruby-version">[2.4](2.4.md#warning-module)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Warning.html"><code>Warning</code></a> module introduced**
* <span class="ruby-version">[2.5](2.5.md#warn-call-warningwarn)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Kernel.html#method-i-warn"><code>Kernel#warn</code></a> calls <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.5.0/Warning.html#method-i-warn"><code>Warning.warn</code></a> internally
* <span class="ruby-version">[2.5](2.5.md#warn-uplevel-keyword-argument)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Kernel.html#method-i-warn"><code>Kernel#warn</code></a>: `uplevel:` keyword argument allows to tune which line to specify in warning message as a source of warning
* <span class="ruby-version">[2.7](2.7.md#warning-and-)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Warning.html#method-c-5B-5D"><code>Warning::[]</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Warning.html#method-c-5B-5D-3D"><code>Warning::[]=</code></a> to choose which categories of warnings to show; the categories are predefined by Ruby and only can be `:deprecated` or `:experimental` (or none)
  * <span class="ruby-version">[3.0](3.0.md#warningwarn-category-keyword-argument)</span> User code allowed to specify category of its warnings with <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-warn"><code>Kernel#warn</code></a> and intercept the warning category <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Warning.html#method-i-warn"><code>Warning#warn</code></a> with `category:` keyword argument; the list of categories is still closed.

## Concurrency and parallelism[](#concurrency-and-parallelism)

### `Thread`[](#thread)

* <span class="ruby-version">**2.0**</span> Concept of _thread variables_ introduced: methods <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable_get"><code>#thread_variable_get</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable_set"><code>#thread_variable_set</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variables"><code>#thread_variables</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable-3F"><code>#thread_variable?</code></a>. Note that they are different from variables available via <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-5B-5D"><code>Thread#[]</code></a>, which are _fiber-local_.
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-c-handle_interrupt"><code>.handle_interrupt</code></a> to setup handling on exceptions and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-c-pending_interrupt-3F"><code>.pending_interrupt?</code></a>/<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-pending_interrupt-3F"><code>#pending_interrupt?</code></a>
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-join"><code>#join</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-value"><code>#value</code></a> now raises a `ThreadError` if target thread  is the current or main thread.
* <span class="ruby-version">**2.0**</span> Thread-local <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-backtrace_locations"><code>#backtrace_locations</code></a>
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Thread.html#method-i-name"><code>#name</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/Thread.html#method-i-name-3D"><code>#name=</code></a>
* <span class="ruby-version">[2.4](2.4.md#threadreport_on_exception-and-threadreport_on_exception)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Thread.html#method-c-report_on_exception"><code>.report_on_exception</code></a>/<a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Thread.html#method-c-report_on_exception-3D"><code>.report_on_exception=</code></a> and <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Thread.html#method-i-report_on_exception"><code>#report_on_exception</code></a>/<a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Thread.html#method-i-report_on_exception-3D"><code>#report_on_exception=</code></a>
* <span class="ruby-version">[2.5](2.5.md#threadfetch)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Thread.html#method-i-fetch"><code>#fetch</code></a> is to `Thread#[]` like `Hash#fetch` is to `Hash#[]`: it allows to reliably get Fiber-local variable, raising or providing default value when it isn't defined
* <span class="ruby-version">[3.0](3.0.md#threadignore_deadlock-accessor)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Thread.html#method-c-ignore_deadlock"><code>.ignore_deadlock</code></a>/<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Thread.html#method-c-ignore_deadlock-3D"><code>.ignore_deadlock=</code></a>
* <span class="ruby-version">[3.1](3.1.md#threadnative_thread_id)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Thread.html#method-i-native_thread_id"><code>#native_thread_id</code></a>

### `Process`[](#process)

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Process.html#method-c-getsid"><code>.getsid</code></a> for getting session id (unix only).
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-argv0"><code>.argv0</code></a> returns the original value of `$0`.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-setproctitle"><code>.setproctitle</code></a> sets the process title without affecting `$0`.
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-clock_gettime"><code>.clock_gettime</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-clock_getres"><code>.clock_getres</code></a>
* <span class="ruby-version">[2.5](2.5.md#processlast_status-as-an-alias-of-)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/Process.html#method-c-last_status"><code>Process.last_status</code></a> as an alias of `$?`
* <span class="ruby-version">[3.1](3.1.md#process_fork)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Process.html#method-c-_fork"><code>Process._fork</code></a>

<!--
* <span class="ruby-version">**2.2**</span> Process execution methods such as <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Process.html#method-c-spawn"><code>.spawn</code></a> opens the file in write  mode for redirect from `[:out, :err]`.
-->

### `Fiber`[](#fiber)

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Fiber.html#method-i-resume"><code>#resume</code></a> cannot resume a fiber which invokes <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/Fiber.html#method-i-transfer"><code>#transfer</code></a>.
* <span class="ruby-version">**2.2**</span> `callcc` is obsolete, and `Fiber` should be used
* <span class="ruby-version">[2.7](2.7.md#fiberraise)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/Fiber.html#method-i-raise"><code>#raise</code></a>
* <span class="ruby-version">[3.0](3.0.md#non-blocking-fiber-and-scheduler)</span> **Non-blocking <a class="ruby-doc" href="https://docs.ruby-lang.org/en/master/Fiber.html#class-Fiber-label-Non-blocking+Fibers"><code>Fiber</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/master/Fiber/SchedulerInterface.html"><code>Fiber::SchedulerInterface</code></a>**. This is a big and important change, see [detailed explanation and code examples](3.0.md#non-blocking-fiber-and-scheduler) in 3.0's changelog. In brief, Ruby code now can perform non-blocking I/O concurrently from several fibers, with no code changes other than setting a _fiber scheduler_, which should be implemented by a third-party library.
  * <span class="ruby-version">[3.1](3.1.md#fiber-scheduler-new-hooks)</span> New hooks for fiber scheduler: <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-address_resolve"><code>#address_resolve</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-timeout_after"><code>#timeout_after</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-io_read"><code>#io_read</code></a>, and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-io_write"><code>#io_write</code></a>
* <span class="ruby-version">[3.0](3.0.md#fiberbacktrace--backtrace_locations)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-backtrace"><code>#backtrace</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-backtrace_locations"><code>#backtrace_locations</code></a>

<!--
  * <span class="ruby-version">[3.0](3.0.md#fibertransfer-limitations-changed)</span> `#transfer` limitations changed (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-transfer"><code>Fiber#transfer</code></a>)
-->

### `Ractor`[](#ractor)

* <span class="ruby-version">[3.0](3.0.md#ractors)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Ractor.html"><code>Ractors</code></a> introduced.** A long-anticipated concurrency improvement landed in Ruby 3.0. Ractors (at some point known as Guilds) are fully-isolated (without sharing GVL on CRuby) alternative to threads. To achieve thread-safety without global locking, ractors, in general, can't access each other's (or main program/main ractor) data.
* <span class="ruby-version">[3.1](3.1.md#ractors-can-access-module-instance-variables)</span> Ractors can access module instance variables

## Debugging and internals[](#debugging-and-internals)

* <span class="ruby-version">[2.6](2.6.md#rubyvmabstractsyntaxtree)</span> **<a class="ruby-doc" href="https://ruby-doc.org/core-2.6/RubyVM/AbstractSyntaxTree.html"><code>RubyVM::AbstractSyntaxTree</code></a> introduced**
* <span class="ruby-version">[2.6](2.6.md#rubyvmresolve_feature_path)</span> `RubyVM.resolve_feature_path` introduced
  * <span class="ruby-version">[2.7](2.7.md#load_pathresolve_feature_path)</span> ...and was renamed to `$LOAD_PATH.resolve_feature_path`

<!--
* <span class="ruby-version">[2.7](2.7.md#resolve_feature_path-behavior-for-loaded-features-fixed)</span> `$LOAD_PATH.resolve_feature_path` behavior for loaded features fixed
* <span class="ruby-version">[3.1](3.1.md#load_pathresolve_feature_path-does-not-raise)</span> `$LOAD_PATH.resolve_feature_path` does not raise (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/globals_rdoc.html"><code>doc/globals.rdoc</code></a>)
-->

### `Binding`[](#binding)

`Binding` object represents the execution context and allows to pass it around.

* <span class="ruby-version">**2.1**</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_get"><code>#local_variable_get</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_set"><code>#local_variable_set</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_defined-3F"><code>#local_variable_defined?</code></a>**. Besides other things, it allows to use variables with names of Ruby reserved words:
  ```ruby
  def do_something(if:) # you can name argument this way, but can't refer to it in method's body by name
    condition = binding.local_variable_get('if')
    # ...use condition somehow
  end

  # The syntax might be useful for DSLs like
  validate :foo, if: -> { condition }
  ```
  * <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Binding.html#method-i-local_variables"><code>#local_variables</code></a>
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/Binding.html#method-i-receiver"><code>#receiver</code></a>
* <span class="ruby-version">[2.6](2.6.md#bindingsource_location)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/Binding.html#method-i-source_location"><code>#source_location</code></a>

### `GC`[](#gc)

_Note: in the spirit of the rest of this reference, this section only describes the changes in a garbage collector API, not changes of CRuby GC's algorithms._

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/GC/Profiler.html#method-c-raw_data"><code>GC::Profiler.raw_data</code></a>
* <span class="ruby-version">**2.2**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.2.0/GC.html#method-c-latest_gc_info"><code>.latest_gc_info</code></a> returns `:state` to represent current GC status.
* <span class="ruby-version">**2.2**</span> Rename <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/GC.html#method-c-stat"><code>.stat</code></a> entries
* <span class="ruby-version">[2.7](2.7.md#gccompact)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.7.0/GC.html#method-c-compact"><code>.compact</code></a>
* <span class="ruby-version">[3.0](3.0.md#gcauto_compact-accessor)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/GC.html#method-c-auto_compact"><code>.auto_compact</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/GC.html#method-c-auto_compact-3D"><code>.auto_compact=</code></a>
* <span class="ruby-version">[3.1](3.1.md#gc-measuring-total-time)</span> Measuring total time spent in GC: <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/GC.html#method-c-measure_total_time"><code>.measure_total_time</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/GC.html#method-c-measure_total_time-3D"><code>.measure_total_time=</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/GC.html#method-c-stat"><code>.stat</code></a> output updated, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/GC.html#method-c-total_time"><code>.total_time</code></a> added

<!--
* <span class="ruby-version">**2.1**</span> introduced the generational GC a.k.a RGenGC.
* <span class="ruby-version">**2.2**</span> Introduce incremental marking for major GC.
-->

### `TracePoint`[](#tracepoint)

* <span class="ruby-version">**2.0**</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/TracePoint.html"><code>TracePoint</code></a> class is introduced: a fully object-oriented execution tracing API**; it is a replacement of the deprecated `set_trace_func`.
* <span class="ruby-version">[2.4](2.4.md#tracepointcallee_id)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/TracePoint.html#method-i-callee_id"><code>#callee_id</code></a>
* <span class="ruby-version">[2.6](2.6.md#parameters)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/TracePoint.html#method-i-parameters"><code>#parameters</code></a>
* <span class="ruby-version">[2.6](2.6.md#script_compiled-event)</span> `:script_compiled` event (<a class="ruby-doc" href="https://ruby-doc.org/core-2.6/TracePoint.html#class-TracePoint-label-Events">TracePoint: Events</a> (though new event seems to be omitted), <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/TracePoint.html#method-i-instruction_sequence"><code>TracePoint#instruction_sequence</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/TracePoint.html#method-i-eval_script"><code>TracePoint#eval_script</code></a>)
* <span class="ruby-version">[2.6](2.6.md#enable-new-params-target-and-target_line)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.6/TracePoint.html#method-i-enable"><code>#enable</code></a>: new params `target:` and `target_line:`
* <span class="ruby-version">[3.1](3.1.md#tracepointallow_reentry)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/TracePoint.html#method-c-allow_reentry"><code>.allow_reentry</code></a>

### `RubyVM::InstructionSequence`[](#rubyvminstructionsequence)

`InstructionSequence` is an API to interact with Ruby virtual machine bytecode. It is implementation-specific.

* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-c-of"><code>.of</code></a> to get the instruction sequence from a method or a block.
* <span class="ruby-version">**2.0**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-path"><code>#path</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-absolute_path"><code>#absolute_path</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-label"><code>#label</code></a>, <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-base_label"><code>#base_label</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-first_lineno"><code>#first_lineno</code></a> to retrieve information from where the instruction sequence was defined.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-i-to_binary"><code>#to_binary</code></a>
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-c-load_from_binary"><code>.load_from_binary</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-c-load_from_binary_extra_data"><code>.load_from_binary_extra_data</code></a>
* <span class="ruby-version">[2.5](2.5.md#rubyvminstructionsequence-new-methods)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/RubyVM/InstructionSequence.html#method-i-each_child"><code>#each_child</code></a>, <a class="ruby-doc" href="https://ruby-doc.org/core-2.5.0/RubyVM/InstructionSequence.html#method-i-trace_points"><code>#trace_points</code></a>

<!--

* <span class="ruby-version">[2.5](2.5.md#misc)</span> Misc (—)
* <span class="ruby-version">[2.6](2.6.md#misc)</span> Language: Misc (—)
* <span class="ruby-version">[2.6](2.6.md#minor-changes)</span> Minor changes (—)
* <span class="ruby-version">[2.7](2.7.md#other-syntax-changes)</span> Language: Other syntax changes (—)
* <span class="ruby-version">[3.0](3.0.md#other-changes)</span> Language changes: Other changes (—)

* <span class="ruby-version">[3.0](3.0.md#randomdefault-behavior-change)</span> `Random::DEFAULT` behavior change (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Random.html"><code>Random</code></a>)

* <span class="ruby-version">[3.1](3.1.md#marshalload-accepts-a-freeze-option)</span> `Marshal.load` accepts a `freeze:` option (<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Marshal.html#method-c-load"><code>Marshal.load</code></a>)

-->

## Deeper topics[](#deeper-topics)

### Refinements[](#refinements)

Refinements are hygienic replacement for reopening of classes and modules. They allow to add methods to objects on the fly, but unlike reopening classes (known as "monkey-patching" and frequently frowned upon), changes made by refinements are visible only in the file and module the refinement is used. As the adoption of refinements seems to be questionable, the details of their adjustments are put in a separate "deeper topics" section.

* <span class="ruby-version">**2.0**</span> **Refinements are introduced as experimental feature** with <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-refine"><code>Module#refine</code></a> and top-level `using`
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-refine"><code>Module#refine</code></a> and top-level `using` are no longer experimental
* <span class="ruby-version">**2.1**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-using"><code>Module#using</code></a> introduced to activate refinements only in some particular module
* <span class="ruby-version">[2.4](2.4.md#refinements-are-supported-in-symbolto_proc-and-send)</span> Refinements are supported in `Symbol#to_proc` and `send`
* <span class="ruby-version">[2.4](2.4.md#refine-can-refine-modules-too)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Module.html#method-i-refine"><code>#refine</code></a> can refine modules, too
* <span class="ruby-version">[2.4](2.4.md#moduleused_modules)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Module.html#method-c-used_modules"><code>Module.used_modules</code></a>
* <span class="ruby-version">[2.5](2.5.md#refinements-work-in-string-interpolations)</span> Refinements work in string interpolations
* <span class="ruby-version">[2.6](2.6.md#refinements-improved-visibility)</span> Refined methods are achievable with `#public_send` and `#respond_to?`, and implicit `#to_proc`.
* <span class="ruby-version">[2.7](2.7.md#refinements-in-methodinstance_method)</span> Refined methods are achievable with `#method`/`#instance_method`
* <span class="ruby-version">[3.1](3.1.md#refinement-class)</span> **<a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Refinement.html"><code>Refinement</code></a> class** representing the `self` inside the `refine` statement. In particular, new method <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.1/Refinement.html#method-i-import_methods"><code>#import_methods</code></a> became available inside `#refine` providing some (incomplete) remedy for inability to `#include` modules while refining some class.


### Freezing[](#freezing)

Freezing of object makes its state immutable. The important thing about freezing core objects is it allows for many memory optimizations: any instance of the frozen string `"test"` can reference the same representation of the string in the memory.

* <span class="ruby-version">**2.0**</span> Fixnums, Bignums and Floats are frozen. While number values never were mutable, before Ruby 2.0 it was possible to change additional internal state for them, making it weird:
  ```ruby
  10.instance_variable_set('@foo', 5) # works in 1.9, "can't modify frozen Fixnum" in 2.0
  10.instance_variable_get('@foo') # => 5 in Ruby 1.9
  ```
* <span class="ruby-version">**2.1**</span> All symbols are frozen.
* <span class="ruby-version">**2.1**</span> `"string_literal".freeze` is optimized to always return the same object for same literal
* <span class="ruby-version">**2.2**</span> `nil`/`true`/`false` objects are frozen.
* <span class="ruby-version">**2.3**</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/String.html#method-i-2B-40"><code>String#+@</code></a> and <a class="ruby-doc" href="https://docs.ruby-lang.org/en/2.3.0/String.html#method-i-2D-40"><code>#-@</code></a> are added to get mutable/frozen strings.
  * _The methods are mnemonical to those using Celsius temperature scale, where 0 is freezing point, so any "minus-something" is frozen while "plus-something" is not._
* <span class="ruby-version">[2.4](2.4.md#objectclonefreeze-false)</span> <a class="ruby-doc" href="https://ruby-doc.org/core-2.4.0/Object.html#method-i-clone"><code>Object#clone</code></a>: `freeze: false` argument to receive unfrozen clone of a frozen object
  * <span class="ruby-version">[3.0](3.0.md#objectclonefreeze-true)</span> `freeze: true` also works, for consistency.
  * <span class="ruby-version">[3.0](3.0.md#objectclone-passes-freeze-argument-to-initialize_clone)</span> `freeze:` argument is passed to `#initialize_clone`
* <span class="ruby-version">[2.7](2.7.md#core-methods-returning-frozen-strings)</span> Several core methods like `nil.to_s` and `Module.name` return frozen strings
* <span class="ruby-version">[3.0](3.0.md#interpolated-string-literals-are-no-longer-frozen-when--frozen-string-literal-true-is-used)</span> Interpolated String literals are no longer frozen when  <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/syntax/comments_rdoc.html#label-frozen_string_literal+Directive">`# frozen-string-literal: true` pragma</a> is used
* <span class="ruby-version">[3.0](3.0.md#regexp-and-range-objects-are-frozen)</span> `Regexp` and `Range` objects are frozen
* <span class="ruby-version">[3.0](3.0.md#symbolname)</span> <a class="ruby-doc" href="https://docs.ruby-lang.org/en/3.0.0/Symbol.html#method-i-name"><code>Symbol#name</code></a> method that returns a frozen string equivalent of the symbol (`Symbol#to_s` returns mutable one, and changing it to be frozen would cause too much incompatibilities)

## Appendix: Covered Ruby versions release dates[](#appendix-covered-ruby-versions-release-dates)

* <span class="ruby-version">**2.0**</span> — 2013, Feb 24
* <span class="ruby-version">**2.1**</span> — 2013, Dec 25 (the same as every version after this)
* <span class="ruby-version">**2.2**</span> — 2014
* <span class="ruby-version">**2.3**</span> — 2015
* <span class="ruby-version">[2.4](2.4.md)</span> — 2016
* <span class="ruby-version">[2.5](2.5.md)</span> — 2017
* <span class="ruby-version">[2.6](2.6.md)</span> — 2018
* <span class="ruby-version">[2.7](2.7.md)</span> — 2019
* <span class="ruby-version">[3.0](3.0.md)</span> — 2020
* <span class="ruby-version">[3.1](3.1.md)</span> — 2021


