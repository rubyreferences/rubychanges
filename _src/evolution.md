---
title: Ruby Evolution
prev: /
next: 3.1
description: A very brief list of new significant features that emerged in Ruby programming language since version 2.0 (2013).
---

# Ruby Evolution

**A very brief list of new significant features that emerged in Ruby programming language since version 2.0 (2013).**

It is intended as a "bird eye view" that might be of interest for Ruby novices and experts alike, as well as for curious users of other technologies.

It is part of a bigger [Ruby Changes](/) effort, which provides a detailed explanations and justifications on what happens to the language, version by version. The detailed changelog currently covers versions since 2.4, and the brief changelog links to more detailed explanations for those versions (links are under version numbers at the beginning of the list items).

The choice of important features, their grouping, and depth of comment provided are informal and somewhat subjective. The author of this list is focused on the changes of the language as a system of thinking and its syntax/semantics more than on a particular implementation.

As Ruby is highly object-oriented language, most of the changes can be associated with some of its core classes. Nevertheless, a new method in one of the core classes frequently changes the way code could be written, not just adds some small convenience.

**🇺🇦 🇺🇦 This work was started in mid-February, before the start of aggressive full-scale war Russia leads against Ukraine. I am finishing it after my daily volunteer work (delivering food through my district), why my homecity Kharkiv is still constantly bombed. Please care to read two of my appeals to Ruby community before proceeding: [first](https://zverok.space/blog/2022-03-03-WAR.html), [second](https://zverok.space/blog/2022-03-15-STILL-WAR.html). 🇺🇦 🇺🇦**


## General changes

* **2.0** **Refinements are introduced as experimental feature**. It is meant to be a hygienic replacement for contextual extending of modules and classes. The feature became stable in 2.1, but still has questionable mindshare, so the further enhancements to it [are covered in "deeper topics" section](#refinements). Example of refinements usage:
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
* [2.6](2.6.md#non-ascii-constant-names) Non-ASCII constant names allowed
* [2.7](2.7.md#safe-and-taint-concepts-are-deprecated-in-general) "Safe" and "taint" concepts are deprecated in general
* [3.0](3.0.md#changes-in-class-variable-behavior) Class variable behavior became stricter: top-level `@@variable` is prohibited, as well as overriding in descendant classes and included modules.
* [3.0](3.0.md#types) **Type definitions concept is introduced.** The discussion of possible solutions for static or gradual typing and possible syntax of type declarations in Ruby code had been open for years. At 3.0, Ruby’s core team made their mind towards type declaration in _separate files_ and _separate tools_ to check types. Example of type definition syntax:
  ```ruby
  class Dog
    attr_reader name: String

    def initialize: (name: String) -> void

    def bark: (at: Person | Dog | nil) -> String
  end
  ```

<!--
* **2.0** No warning for unused variables starting with `_`
* [2.5](2.5.md#top-level-constant-look-up-is-removed) Top-level constant look-up is removed
* [3.1](3.1.md#multiple-assignment-evaluation-order-change) Multiple assignment evaluation order change (—)
-->

## Expressions

* **2.3** **Safe navigation operator**:
  ```ruby
  s = 'test'
  s&.length # => 4
  s = nil
  s&.length # => nil, instead of NoMethodError
  ```
* [2.4](2.4.md#multiple-assignment-allowed-in-conditional-expression) Multiple assignment allowed in conditional expression
* [2.4](2.4.md#toplevel-return) Toplevel `return` to stop interpreting the file immediately; useful for cases like platform-specific classes, where instead of wrapping the whole file in `if SOMETHING_SUPPORTED...`, you can just `return unless SOMETHING_SUPPORTED` at the beginning.

### Pattern-matching

* [2.7](2.7.md#pattern-matching) **[Pattern-matching](https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html) introduced as an experimental feature** that allows to deeply unpack/check nested data structures:
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
* [3.0](3.0.md#one-line-pattern-matching-with-) `=>` pattern-matching expression introduced
  ```ruby
  {a: 1, b: 2} => {a:} # -- deconstructs and assigns to local variable `a`; fails if pattern not matched
  long.chain.of.computations => result # can also be used as a "rightward assignment"
  ```
* [3.0](3.0.md#in-as-a-truefalse-check) `in` pattern-matching expression repurposed as a `true`/`false` check
 ```ruby
  if {a: 1, b: 2} in {a:} # just "check if match", returning true/false; also deconstructs
  # ...
  ```
* [3.0](3.0.md#find-pattern) [Find pattern](https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html#label-Patterns) is supported: `[*elements_before, <complicated pattern>, *elements_after]`
* [3.1](3.1.md#expressions-and-non-local-variables-allowed-in-pin-operator-) Expressions and non-local variables [allowed in pin operator `^`](https://docs.ruby-lang.org/en/3.1/syntax/pattern_matching_rdoc.html#label-Variable+pinning)
* [3.1](3.1.md#parentheses-can-be-omitted-in-one-line-pattern-matching) Parentheses can be omitted in one-line pattern matching:
  ```ruby
  {a: 1, b: 2} => a:
  ```

## `Kernel`

`Kernel` is a module included in every object, providing most of the methods that look "top-level", like `puts`, `require`, `raise` and so on.

* **2.0** [#__dir__](https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-__dir__): absolute path to current source file
* **2.0** [#caller_locations](https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-caller_locations) which returns an array of frame information objects, in a form of new class [Thread::Backtrace::Location](https://docs.ruby-lang.org/en/2.0.0/Thread/Backtrace/Location.html)
* **2.0** [#caller](https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-caller) accepts second optional argument `n` which specify required caller size.
* **2.2** [#throw](https://docs.ruby-lang.org/en/2.2.0/Kernel.html#method-i-throw) raises `UncaughtThrowError`, subclass of `ArgumentError` when there is no corresponding catch block, instead of `ArgumentError`.
* **2.3** [#loop](https://docs.ruby-lang.org/en/2.3.0/Kernel.html#method-i-loop): when stopped by a `StopIteration` exception, returns what the enumerator has returned instead of `nil`
* [2.5](2.5.md#pp) [#pp](https://docs.ruby-lang.org/en/2.5.0/Kernel.html#method-i-pp) debug printing method is available without `require 'pp'`
* [3.1](3.1.md#kernelload-module-as-a-second-argument) [#load](https://docs.ruby-lang.org/en/3.1/Kernel.html#method-i-load) allows to pass module as a second argument, to load code inside module specified

<!--
* [3.0](3.0.md#kerneleval-changed-processing-of-__file__-and-__line__) `#eval` changed processing of `__FILE__` and `__LINE__` (—)
-->


## `Object`

`Object` is a class most other classes are inherited from (save for very special cases when the `BasicObject` is inherited). So the methods defined in `Object` are available in most of the objects.<br/><br/>_Unlike `Kernel`'s method described above, `Object`'s methods are public. E.g. every object has private `#puts` from `Kernel` that it can use inside its own methods, and every object has public `#inspect` from `Object`, that can be called by other objects._

* **2.0** [#respond_to?](https://docs.ruby-lang.org/en/2.0.0/Object.html#method-i-respond_to-3F) against a protected method now returns `false` by default, can be overrided by `respond_to?(:foo, true)`.
* **2.0** [#respond_to_missing?](https://docs.ruby-lang.org/en/2.0.0/Object.html#method-i-respond_to_missing-3F), `#initialize_clone`, `#initialize_dup` became private.
* **2.1** [#singleton_method](https://docs.ruby-lang.org/en/2.1.0/Object.html#method-i-singleton_method)
* **2.2** [#itself](https://docs.ruby-lang.org/en/2.2.0/Object.html#method-i-itself) introduced, just returning the object and making code like this easier:
  ```ruby
  array_of_objects.group_by(&:itself)
  ```
* [2.6](2.6.md#then-as-an-alias-for-yield_self) **[#then](https://docs.ruby-lang.org/en/2.6.0/Object.html#method-i-then)** (initially introduced as <span class="ruby-version">[2.5](2.5.md#yield_self)</span> `#yield_self`) for chainable computation, akin to Elixir's `|>`:
  ```ruby
  [BASE_URL, path].join('/')
    .then { |url| open(url).read }
    .then { |body| JSON.parse(body, symbolyze_names: true) }
    .dig(:data, :items)
    .then { |items| File.write('response.yml', items.to_yaml) }
  ```

<!--
* **2.0** `#inspect` does not call `#to_s` anymore (it could cause a weird effect if `#to_s` is redefined).
-->

## Modules and classes

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

* **2.0** **[#prepend](https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepend) introduced**: like `#include`, but adds prepended module to the beginning of the ancestors chain (also  [#prepended](https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepended) and [#prepend_features](https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-prepend_features) hooks):
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
* **2.0** [#const_get](https://docs.ruby-lang.org/en/2.0.0/Module.html#method-i-const_get) accepts a qualified constant string, e.g. `Object.const_get("Foo::Bar::Baz")`
* **2.1** [#ancestors](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-ancestors)
* **2.1** The ancestors of a singleton class now include singleton classes,  in particular itself.
* **2.1** [#singleton_class?](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-singleton_class-3F)
* **2.1** [#include](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-include) and [#prepend](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-prepend) are now public methods, so one can do `AnyClass.include AnyModule` without resorting to `send(:include, ...)` (which people did anyway)
* **2.3** [#deprecate_constant](https://docs.ruby-lang.org/en/2.3.0/Module.html#method-i-deprecate_constant)
* [2.5](2.5.md#module-methods-for-defining-methods-and-accessors-became-public) methods for defining methods and accessors (like [#attr_reader](https://docs.ruby-lang.org/en/2.5.0/Module.html#method-i-attr_reader) and [#define_method](https://docs.ruby-lang.org/en/2.5.0/Module.html#method-i-define_method)) became public
* [2.6](2.6.md#modulemethod_defined-inherit-argument) [#method_defined?](https://ruby-doc.org/core-2.6/Module.html#method-i-method_defined-3F): `inherit` argument
* [2.7](2.7.md#const_source_location) **[#const_source_location](https://ruby-doc.org/core-2.7.0/Module.html#method-i-const_source_location)** allows to query where some constant (including modules and classes) was first defined.
* [2.7](2.7.md#autoload-inherit-argument) [#autoload?](https://ruby-doc.org/core-2.7.0/Module.html#method-i-autoload-3F): `inherit` argument.
* [3.0](3.0.md#include-and-prepend-now-affects-modules-including-the-receiver) `#include` and `#prepend` now affects modules that already include the receiver:
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
* [3.0](3.0.md#improved-method-visibility-declaration) Changes in return values/accepted parameters of several methods, making code like `private attr_reader :a, :b, :c` work ([#attr_reader](https://docs.ruby-lang.org/en/3.0/Module.html#method-i-attr_reader) started to return arrays of symbols, and [#private](https://docs.ruby-lang.org/en/3.0/Module.html#method-i-private) accepts arrays)
* [3.1](3.1.md#classsubclasses) [Class#subclasses](https://docs.ruby-lang.org/en/3.1/Class.html#method-i-subclasses)
* [3.1](3.1.md#moduleprepend-behavior-change) [Module#prepend](https://docs.ruby-lang.org/en/3.1/Module.html#method-i-prepend) behavior changed to take effect even if the same module is already included.
* [3.1](3.1.md#moduleprivate-public-protected-and-module_function-return-their-arguments) [#private](https://docs.ruby-lang.org/en/3.1/Module.html#method-i-private) and other visibility methods return their arguments, to allow usage in macros like `memoize private def my_method...`

<!--
* **2.0** `#define_method` accepts a UnboundMethod from a Module.
-->

## Methods

This section lists changes in how methods are defined and invoked, as well as new/changed methods of core classes `Method` and `UnboundMethod`. Note: some of the behavior of method definition APIs in context of containing modules is covered in the above [section about modules](#modules-and-classes).

* **2.0** **Keyword arguments.** Before Ruby 2.0, keyword arguments could've been imitated to some extent with last hash argument without parenthises. In Ruby 2.0, proper keyword arguments were introduced. At first, they could only be optional (default value should've always been defined):
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
  * **2.1** **Required keyword arguments** introduced:
    ```ruby
    def render(data, separator:, indent: 2) # will raise if `separator:` argument is not passed
    ```
* **2.0** top-level `define_method` which defines a global function.
* **2.1** `def` now returns the symbol of its name instead of `nil`. Usable to use in class-level "macros" method:
  ```ruby
  # before:
  def foo
  end
  private :foo

  # after:
  private def foo # `private` will receive :foo that `def` returned
  end
  ```
  * [Module#define_method](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-define_method) and [Object#define_singleton_method](https://docs.ruby-lang.org/en/2.1.0/Object.html#method-i-define_singleton_method) also return the symbols of the defined methods, not the methods/procs
* **2.2** [Method#curry](https://docs.ruby-lang.org/en/2.2.0/Method.html#method-i-curry):
  ```ruby
  writer = File.method(:write).curry(2).call('test.txt') # curry with 2 arguments, supply first of them
  # Now, the `writer` can be used as a 1-argument callable object:
  writer.call('content') # Invokes File.write('test.txt', 'content')
  ```
* **2.2** [Method#super_method](https://docs.ruby-lang.org/en/2.2.0/Method.html#method-i-super_method)
* [2.5](2.5.md#method) [Method#===](https://ruby-doc.org/core-2.5.0/Method.html#method-i-3D-3D-3D), allowing to use it in `grep` and `case`:
  ```ruby
  require 'prime'
  (1..50).grep(Prime.method(:prime?))
  #=> [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
  ```
* [2.7](2.7.md#selfprivate_method) `self.<private_method>` [is allowed](https://ruby-doc.org/core-2.7.0/syntax/modules_and_classes_rdoc.html#label-Visibility)
* [2.7](2.7.md#keyword-argument-related-changes) **[Big Keyword Argument Separation](https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/):** some incompatibilities were introduced by need, so the distinction of keyword arguments and hashes in method arguments was more clear, handling numerous irritating edge cases.
* [2.7](2.7.md#keyword-argument-related-changes) Introduce argument forwarding with `method(...)` syntax. As after the keyword argument separation "delegate everything" syntax became more complicated (you need to use and pass `(*args, **kwargs)`, because just `*args` wouldn't always work), simplified syntax was introduced:
  ```ruby
  def wrap_log(...) # this is literal code that can be used now, not a placeholder for a demo
    puts "Logging at #{Time.now}"
    log.call(...)
  end

  wrap_log(:info, "Foo", context: some_context) # both positional and keyword args are passed successfully
  ```
* [2.7](2.7.md#better-methodinspect) Better [Method#inspect](https://ruby-doc.org/core-2.7.0/Method.html#method-i-inspect) with signature and source code location
* [2.7](2.7.md#unboundmethodbind_call) [UnboundMethod#bind_call](https://ruby-doc.org/core-2.7.0/UnboundMethod.html#method-i-bind_call)
* [3.0](3.0.md#arguments-forwarding--supports-leading-arguments) Arguments forwarding (`...`) [supports](https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Argument+Forwarding) leading arguments
* [3.0](3.0.md#endless-method-definition) **"[Endless](https://docs.ruby-lang.org/en/master/syntax/methods_rdoc.html)" (one-line) method definition**:
  ```ruby
  def square(n) = n**n
  ```
* [3.1](3.1.md#methodunboundmethod-public-private-protected) [Method#private?](https://docs.ruby-lang.org/en/3.1/Method.html#method-i-private-3F), `#protected?`, `#public?`, same are defined for `UnboundMethod`
  * _Note: it is possible the change would be reverted in 3.2_
* [3.1](3.1.md#values-in-hash-literals-and-keyword-arguments-can-be-omitted) **Values in keyword arguments [can be omitted](https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Keyword+Arguments)**:
  ```ruby
  x = 100
  p(x:) # same as p(x: x), prints: {:x => 100}
  ```
* [3.1](3.1.md#anonymous-block-argument) Anonymous [block argument](https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html#label-Block+Argument):
  ```ruby
  def logged_open(filename, &)
    puts "Opening #{filename}..."
    File.open(filename, &)
  end
  ```

<!--
* [3.1](3.1.md#inside-endless-method-definitions-method-calls-without-parenthesis-are-allowed) Inside "endless" method definitions, method calls without parenthesis are allowed (— ([doc/syntax/methods.rdoc](https://docs.ruby-lang.org/en/3.1/syntax/methods_rdoc.html) doesn't mention new or old behavior.))
-->

## Procs, blocks and `Proc` class

* **2.0** removed `Proc#==` and `#eql?` so two procs are equal only when they are the same object.
* **2.2** `ArgumentError` is no longer raised when lambda `Proc` is passed as a block, and the number of yielded arguments does not match the formal arguments of the lambda, if just an array is yielded and its length matches.
* [2.6](2.6.md#proc-composition) **`Proc` composition with [>>](https://docs.ruby-lang.org/en/2.6.0/Proc.html#method-i-3E-3E) and [<<](https://docs.ruby-lang.org/en/2.6.0/Proc.html#method-i-3C-3C)**:
  ```ruby
  PROCESSOR = proc { |str| '{' + str + '}' } >> :upcase.to_proc >> method(:puts)
  %w[test me please].map(&PROCESSORS)
  # prints
  #   {TEST}
  #   {ME}
  #   {PLEASE}
  ```
* [2.7](2.7.md#numbered-block-parameters) **[Numbered block parameters](https://docs.ruby-lang.org/en/2.7.0/Proc.html#class-Proc-label-Numbered+parameters)**:
  ```ruby
  [1, 2, 3].map { _1 * 100 } # => 100, 200, 300
  ```

<!--
* **2.1** Returning from lambda proc now always exits from the Proc, not from the method where the lambda is created.  Returning from non-lambda proc exits from the method, same as the former behavior.
* [3.0](3.0.md#procs-with-rest-arguments-and-keywords-change-of-autosplatting-behavior) Keyword arguments are now fully separated from positional arguments: Procs with "rest" arguments and keywords: change of autosplatting behavior (—)
* [3.0](3.0.md#symbolto_proc-reported-as-lambda) Procs/lambdas: `Symbol#to_proc` reported as lambda (—)
* [3.0](3.0.md#kernellambda-warns-if-called-without-a-literal-block) `Kernel#lambda` warns if called without a literal block (—)
* [3.0](3.0.md#proc-and-eql) Procs/lambdas: `Proc#==` and `#eql?` ([Proc#==](https://docs.ruby-lang.org/en/3.0.0/Proc.html#method-i-3D-3D))
-->

## `Comparable`

Included in many classes to implement comparison methods. Once class defines a method `#<=>` for object comparison (returning `-1`, `0`, `1`, or `nil`) and includes `Comparable`, methods like `==`, `<`, `<=` etc. are defined automatically. Changes in `Comparable` module affect most of comparable objects in Ruby, including core ones like numbers and strings.

* **2.3** `#==` no longer rescues exceptions (so if owner class' `<=>` raises, the user will see original exception)
* [2.4](2.4.md#comparableclamp) **[#clamp](https://ruby-doc.org/core-2.4.0/Comparable.html#method-i-clamp)**:
  ```ruby
  123.clamp(50, 100) # => 100
  23.clamp(50, 100) # => 50
  53.clamp(50, 100) # => 53
  ```
* [2.7](2.7.md#comparableclamp-with-range) **[#clamp](https://ruby-doc.org/core-2.7.0/Comparable.html#method-i-clamp) supports `Range` argument**:
  ```ruby
  123.clamp(0..100)
  # one-sided clamp with endless/beginless ranges work too!
  -123.clamp(0..) #=> 0
  123.clamp(..100) #=> 100
  ```

## `Numeric`

* **2.1** [Fixnum#bit_length](https://docs.ruby-lang.org/en/2.1.0/Fixnum.html#method-i-bit_length), [Bignum#bit_length](https://docs.ruby-lang.org/en/2.1.0/Bignum.html#method-i-bit_length)
* **2.1** **Added suffixes for integer and float literals: `r`, `i`, and `ri`**:
  ```ruby
  1/3r   # => (1/3), Rational
  2 + 5i # => (2 + 5i), Complex
  ```
* **2.2** [Float#next_float](https://docs.ruby-lang.org/en/2.2.0/Float.html#method-i-next_float), [#prev_float](https://docs.ruby-lang.org/en/2.2.0/Float.html#method-i-prev_float)
* **2.3** [Numeric#positive?](https://docs.ruby-lang.org/en/2.3.0/Numeric.html#method-i-positive-3F) and [#negative?](https://docs.ruby-lang.org/en/2.3.0/Numeric.html#method-i-negative-3F)
* [2.4](2.4.md#fixnum-and-bignum-are-unified-into-integer) **`Fixnum` and `Bignum` are unified into [Integer](https://ruby-doc.org/core-2.4.0/Integer.html)**
* [2.4](2.4.md#numericfinite-and-infinite) [Numeric#infinite?](https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-infinite-3F) and [#finite?](https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-finite-3F)
* [2.4](2.4.md#integerdigits) [Integer#digits](https://ruby-doc.org/core-2.4.0/Integer.html#method-i-digits)
* [2.4](2.4.md#ndigits-optional-argument-for-rounding-methods) Rounding methods [Numeric#ceil](https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-ceil), [Numeric#floor](https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-floor), [Numeric#truncate](https://ruby-doc.org/core-2.4.0/Numeric.html#method-i-truncate): `ndigits` optional argument.
* [2.4](2.4.md#half-option-for-round-method) [Integer#round](https://ruby-doc.org/core-2.5.0/Integer.html#method-i-round) and [Float#round](https://ruby-doc.org/core-2.5.0/Float.html#method-i-round): `half:` argument
* [2.5](2.5.md#pow-modulo-argument) [Integer#pow](https://ruby-doc.org/core-2.5.0/Integer.html#method-i-pow): `modulo` argument
* [2.5](2.5.md#allbits-anybits-nobits) [Integer#allbits?](https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F), [#anybits?](https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F), [#nobits?](https://ruby-doc.org/core-2.5.0/Integer.html#method-i-allbits-3F)
  ```ruby
  # classic way of checking some flags:
  (object.flags & FLAG_ADMIN) > 0
  # new way:
  object.flags.anybits?(FLAG_ADMIN)
  ```
* [2.5](2.5.md#sqrt) [Integer.sqrt](https://ruby-doc.org/core-2.5.0/Integer.html#method-c-sqrt)
* [2.7](2.7.md#integer-with-range) [Integer#[]](https://ruby-doc.org/core-2.7.0/Integer.html#method-i-5B-5D) supports range of bits
* [3.1](3.1.md#integertry_convert) [Integer.try_convert](https://docs.ruby-lang.org/en/3.1/Integer.html#method-c-try_convert)

<!--
* **2.2** `Math.log` now raises `Math::DomainError` instead of returning NaN if the  base is less than 0, and returns NaN instead of -infinity if both of two arguments are 0.
* **2.2** `Math.atan2` now returns values like as expected by C99 if both two arguments are infinity.
* [2.7](2.7.md#complex) `Complex#<=>` ([Complex#<=>](https://ruby-doc.org/core-2.7.0/Complex.html#method-i-3C-3D-3E))
-->

## Strings, symbols, regexps, encodings

* **2.0** **Big encoding cleanup**:
  * Default source encoding is changed to UTF-8 (was US-ASCII)
  * Iconv has been removed from standard library; core methods like [String#encode](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-encode) and [String#force_encoding](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-force_encoding) (introduced in 1.9) should be preferred
* **2.0** **`%i` symbol array literals shortcut**:
  ```ruby
  %i[first_name last_name age] # => [:first_name, :last_name, :age]
  ```
* **2.0** [String#b](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-b) to set string encoding as ASCII-8BIT (aka "binary", raw bytes).
* **2.1** [String#scrub](https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-scrub) and [#scrub!](https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-scrub-21) to verify and fix invalid byte sequence.
* **2.2** Most symbols which are returned by [String#to_sym](https://docs.ruby-lang.org/en/2.1.0/String.html#method-i-to_sym) are garbage collectable. _While it might be perceived as an implementation detail, it means also the change in language use: there is no need to avoid symbols where they are more expressive, even if there are a lot of them._
* **2.2** [String#unicode_normalize](https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalize), [#unicode_normalize!](https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalize-21), and [#unicode_normalized?](https://docs.ruby-lang.org/en/2.2.0/String.html#method-i-unicode_normalized-3F)
* **2.3** **`<<~` HERE-document literal** (removing the leading spaces):
  ```ruby
  text = <<~HERE
          The text, indented for readability.
          No leading spaces please.
         HERE

  p text
  # => "The text, indented for readability.\nNo leading spaces please.\n"
  ```
* **2.3** [String.new](https://docs.ruby-lang.org/en/2.3.0/String.html#method-c-new) accepts keyword argument `encoding:`
* [2.4](2.4.md#unicode-case-conversions) Case conversions ([String#downcase](https://ruby-doc.org/core-2.4.0/String.html#method-i-downcase), [String#upcase](https://ruby-doc.org/core-2.4.0/String.html#method-i-upcase), and other related methods) fully support Unicode:
  ```ruby
  'Straße'.upcase # => 'STRASSE'
  'İzmir'.upcase(:turkic) # => İZMİR -- locale-specific case conversion
  ```
* [2.4](2.4.md#stringnewcapacity-size) [String::new](https://ruby-doc.org/core-2.4.0/String.html#method-c-new): `capacity:` argument to pre-allocate memory if it is known the string will grow
* [2.4](2.4.md#casecmp) [String#casecmp?](https://ruby-doc.org/core-2.4.0/String.html#method-i-casecmp-3F), [Symbol#casecmp?](https://ruby-doc.org/core-2.4.0/Symbol.html#method-i-casecmp-3F) as a more expressive version of `#casecmp` when boolean value is needed (`#casecmp` returns `-1`/`0`/`1`):
  ```ruby
  'FOO'.casecmp?('foo') # => true
  'Straße'.casecmp?('STRASSE') # => true, Unicode-aware
  ```
* [2.4](2.4.md#stringconcat-and-prepend-accept-multiple-arguments) [String#concat](https://ruby-doc.org/core-2.4.0/String.html#method-i-concat) and [#prepend](https://ruby-doc.org/core-2.4.0/String.html#method-i-prepend) accept multiple arguments
* [2.4](2.4.md#stringunpack1) [String#unpack1](https://ruby-doc.org/core-2.4.0/String.html#method-i-unpack1) as a shortcut to `"foo".unpack(...).first`
* [2.4](2.4.md#match-method) [Regexp#match?](https://ruby-doc.org/core-2.4.0/Regexp.html#method-i-match-3F), [String#match?](https://ruby-doc.org/core-2.4.0/String.html#method-i-match-3F), and [Symbol#match?](https://ruby-doc.org/core-2.4.0/Symbol.html#method-i-match-3F) for when it is only necessary to know "if it matches or not". Unlike `=~` and `#match`, the methds don't alocate `MatchData` instance, which might make the check more efficient.
* [2.4](2.4.md#matchdata-better-support-for-named-captures) `MatchData`: better support for named captures: [#named_captures](https://ruby-doc.org/core-2.4.0/MatchData.html#method-i-named_captures), [#values_at](https://ruby-doc.org/core-2.4.0/MatchData.html#method-i-values_at)
* [2.5](2.5.md#delete_prefix-delete_prefix-delete_suffix-delete_suffix) [String#delete_prefix](https://ruby-doc.org/core-2.5.0/String.html#method-i-delete_prefix) and [#delete_suffix](https://ruby-doc.org/core-2.5.0/String.html#method-i-delete_suffix)
* [2.5](2.5.md#each_grapheme_cluster-and-grapheme_clusters) [String#grapheme_clusters](https://ruby-doc.org/core-2.5.0/String.html#method-i-grapheme_clusters)and [#each_grapheme_cluster](https://ruby-doc.org/core-2.5.0/String.html#method-i-each_grapheme_cluster)
* [2.5](2.5.md#undump) [String#undump](https://ruby-doc.org/core-2.5.0/String.html#method-i-undump) deserialization method, symmetric to `#dump`
* [2.5](2.5.md#start_with-accepts-a-regexp) [String#start_with?](https://ruby-doc.org/core-2.6/String.html#method-i-start_with-3F) accepts a regexp (but not `#end_with?`)
* [2.5](2.5.md#regexp-absence-operator) `Regexp`: absence operator `(?~<pattern>)`: match everything except this particular pattern
* [2.6](2.6.md#stringsplit-with-block) [String#split](https://ruby-doc.org/core-2.6/String.html#method-i-split) supports block:
  ```ruby
  "several\nlong\nlines".split("\n") { |part| puts part if part.start_with?('l') }
  # prints:
  #   long
  #   lines
  # => "several\nlong\nlines"
  ```
* [2.7](2.7.md#symbolstart_with-and-end_with) [Symbol#end_with?](https://ruby-doc.org/core-2.7.0/Symbol.html#method-i-end_with-3F) and [#start_with?](https://ruby-doc.org/core-2.7.0/Symbol.html#method-i-start_with-3F) _as a part of making symbols as convenient as strings, while maintaining their separate meaning_
* [3.1](3.1.md#stringunpack-and-unpack1-offset-argument) [String#unpack](https://docs.ruby-lang.org/en/3.1/String.html#method-i-unpack) and [#unpack1](https://docs.ruby-lang.org/en/3.1/String.html#method-i-unpack1) added `offset:` argument, to unpack data from the middle of a stream.
* [3.1](3.1.md#matchdatamatch-and-match_length) [MatchData#match](https://docs.ruby-lang.org/en/3.1/MatchData.html#method-i-match) and [MatchData#match_length](https://docs.ruby-lang.org/en/3.1/MatchData.html#method-i-match_length)

<!--
* **2.0** Switch Regexp engine to [Onigmo](https://github.com/k-takata/Onigmo)
* **2.1** `pack/unpack` (Array/String): `Q!` and `q!` directives for long long type if platform has the type.
* [2.5](2.5.md#casecmp-and-casecmp-return-nil-for-non-string-arguments) `String#casecmp` and `#casecmp?` return `nil` for non-string arguments ([String#casecmp](https://ruby-doc.org/core-2.5.0/String.html#method-i-casecmp), [String#casecmp?](https://ruby-doc.org/core-2.5.0/String.html#method-i-casecmp-3F))
* [2.5](2.5.md#string--optimized-for-memory-preserving) `String#-@` optimized for memory preserving ([String#-@](https://ruby-doc.org/core-2.5.0/String.html#method-i-2D-40))
* [3.0](3.0.md#string-always-returning-string) `String`: always returning `String` (—)
-->

## `Struct`

* [2.5](2.5.md#struct-with-keyword-arguments) **Structs [initialized](https://docs.ruby-lang.org/en/2.5.0/Struct.html#method-c-new) by keywords**:
  ```ruby
  User = Struct.new(:name, :email, keyword_init: true)
  User.new(name: 'Matz', email: 'matz@ruby-lang.org')
  ```
* [3.1](3.1.md#warning-on-passing-keywords-to-a-non-keyword-initialized-struct) Warning on passing keywords to a non-keyword-initialized struct
* [3.1](3.1.md#structclasskeyword_init) [Strict::keyword_init?](https://docs.ruby-lang.org/en/3.1/Struct.html#method-c-keyword_init-3F)

## `Time`

* [2.5](2.5.md#timeat-units) [Time.at](https://ruby-doc.org/core-2.5.0/Time.html#method-c-at) supports units
* [2.6](2.6.md#time-support-for-timezones) **Support for [timezones](https://ruby-doc.org/core-2.6/Time.html#class-Time-label-Timezone+argument).** The timezone object should be provided by external library; expectation of its API matches the most popular [tzinfo](https://github.com/tzinfo/tzinfo):
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
* [2.7](2.7.md#floor-and-ceil) [Time#floor](https://ruby-doc.org/core-2.7.0/Time.html#method-i-floor) and [#ceil](https://ruby-doc.org/core-2.7.0/Time.html#method-i-ceil)
* [3.1](3.1.md#in-parameter-for-constructing-time) [.new](https://docs.ruby-lang.org/en/3.1/Time.html#method-c-new), [.at](https://docs.ruby-lang.org/en/3.1/Time.html#method-c-at), and [.now](https://docs.ruby-lang.org/en/3.1/Time.html#method-c-now): `in: time_zone_or_offset` parameter for constructing time
  ```ruby
  Time.now(in: TZInfo::Timezone.get('America/New_York'))
  # => 2022-07-09 06:25:06.162617846 -0400
  Time.new(2022, 7, 1, 14, 30, in: '+05:00')
  # => 2022-07-01 14:30:00 +0500
  ```

<!--
* **2.0** `Time#to_s` now returns US-ASCII encoding instead of BINARY.
* [2.7](2.7.md#inspect-includes-subseconds) `Time#inspect` includes subseconds ([Time#inspect](https://ruby-doc.org/core-2.7.0/Time.html#method-i-inspect))
* [3.1](3.1.md#strftime-supports--0000-offset) `#strftime` supports `-00:00` offset ([Time#strftime](https://docs.ruby-lang.org/en/3.1/Time.html#method-i-strftime))
-->

## Enumerables, collections, and iteration

* **2.0** A decision was made to make a clearer separation of methods returning enumerators to methods calculating the value and returning array immediately, namely:
  * [String#lines](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-lines), [#chars](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-chars), [#codepoints](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-codepoints), [#bytes](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-bytes) now return arrays instead of an enumerators (methods for returning enumerators are [#each_line](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-each_line), [#each_char](https://docs.ruby-lang.org/en/2.0.0/String.html#method-i-each_char) and so on).
  * [IO#lines](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-lines), [#bytes](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-bytes), [#chars](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-chars) and [#codepoints](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-codepoints) are deprecated in favor of [#each_line](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-each_line), [#each_byte](https://docs.ruby-lang.org/en/2.0.0/IO.html#method-i-each_byte) and so on.
* **2.0** Binary search introduced in core with [Range#bsearch](https://docs.ruby-lang.org/en/2.0.0/Range.html#method-i-bsearch) and [Array#bsearch](https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-bsearch).
* **2.3** **`#dig` introduced** (in [Array](https://docs.ruby-lang.org/en/2.3.0/Array.html#method-i-dig), [Hash](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-dig), and [Struct](https://docs.ruby-lang.org/en/2.3.0/Struct.html#method-i-dig)) for atomic nested data navigation:
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

### Numeric iteration

* **2.1** [Numeric#step](https://docs.ruby-lang.org/en/2.1.0/Numeric.html#method-i-step) allows the limit argument to be omitted, producing `Enumerator`. Keyword arguments `to` and `by` are introduced for ease of use:
  ```ruby
  1.step(by: 5)         # => #<Enumerator: 1:step({:by=>5})>
  1.step(by: 5).take(3) #=> [1, 6, 11]
  ```
* [2.6](2.6.md#enumeratorarithmeticsequence) **[Enumerator::ArithmeticSequence](https://ruby-doc.org/core-2.6/Enumerator/ArithmeticSequence.html) is introduced** as a type returned by [Range#step](https://ruby-doc.org/core-2.6/Range.html#method-i-step) and [Numeric#step](https://ruby-doc.org/core-2.6/Numeric.html#method-i-step):
  ```ruby
  1.step(by: 5)     # => (1.step(by: 5)) -- more expressive representation than above
  (1..200).step(3)  # => ((1..200).step(3))
  # It is also more powerful than generic Enumerator, as there is more knowledge about
  # the nature of the sequence:
  (1..200).step(3).last(2) # => [196, 199]
  ```
* [2.6](2.6.md#range-alias) `Range#%` alias for `Range#step` for expressiveness: `(1..10) % 2` produces `ArithmeticSequence` with meaning "from 1 to 10, each second element"; since Ruby 3.0, this can be used to slicing arrays:
  ```ruby
  (0..) % 3
  letters = ('a'..'z').to_a
  letters[(0..) % 3]
  #=> ["a", "d", "g", "j", "m", "p", "s", "v", "y"]
  ```

### `Enumerable` and `Enumerator`

* **2.0** **The concept of lazy enumerator introduced with [Enumerable#lazy](https://docs.ruby-lang.org/en/2.0.0/Enumerable.html#method-i-lazy) and [Enumerator::Lazy](https://docs.ruby-lang.org/en/2.0.0/Enumerator/Lazy.html)**:
  ```ruby
  # If source is very large or has side effects like network reading, the following code will
  # first read it all, then produce intermediate array on each step
  source.select { some_condition }.map { some_transformation }.first(3)

  # while this code will just stack together operations, and then produce items one by one, till
  # the first 3 results are received:
  #      vvvv
  source.lazy.select { some_condition }.map { some_transformation }.first(3)
  ```
* **2.0** [Enumerator#size](https://docs.ruby-lang.org/en/2.0.0/Enumerator.html#method-i-size) for on-demand size calculation when possible. The code that creates Enumerator, might pass `size` argument to [Enumerator.new](https://docs.ruby-lang.org/en/2.0.0/Enumerator.html#method-c-new) (value or a callable object) if it can calculate the amount of objects to enumerate.
  * [Range#size](https://docs.ruby-lang.org/en/2.0.0/Range.html#method-i-size) added, returning non-`nil` value only for integer ranges
* **2.2** [Enumerable#slice_after](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-slice_after) and [#slice_when](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-slice_when)
* **2.2** [Enumerable#min](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-min), [#min_by](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-min_by), [#max](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-max) and [#max_by](https://docs.ruby-lang.org/en/2.2.0/Enumerable.html#method-i-max) support optional argument to return multiple elements:
  ```ruby
  [1, 6, 7, 2.3, -100].min(3) # => [-100, 1, 2.3]
  ```
* **2.3** [Enumerable#grep_v](https://docs.ruby-lang.org/en/2.3.0/Enumerable.html#method-i-grep_v) and [#chunk_while](https://docs.ruby-lang.org/en/2.3.0/Enumerable.html#method-i-chunk_while)
* [2.4](2.4.md#sum) [Enumerable#sum](https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-sum) as a generalized shortcut for `reduce(:+)`; might be redefined in descendants (like `Array`) for efficiency.
* [2.4](2.4.md#uniq) [Enumerable#uniq](https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-uniq)
* [2.5](2.5.md#enumerableany-all-none-and-one-accept-patterns) [Enumerable#all?](https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-all-3F), [#any?](https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-any-3F), [#none?](https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-none-3F), and [#one?](https://ruby-doc.org/core-2.5.0/Enumerable.html#method-i-one-3F) accept patterns (any objects defining `#===`):
  ```ruby
  objects.all?(Numeric)
  ages.any?(18..60)
  strings.none?(/admin/i)
  ```
* [2.6](2.6.md#enumerator-chaining) **`Enumerator` chaining with [Enumerator#+](https://ruby-doc.org/core-2.6/Enumerator.html#method-i-2B) and [Enumerable#chain](https://ruby-doc.org/core-2.6/Enumerable.html#method-i-chain), producing [Enumerator::Chain](https://ruby-doc.org/core-2.6/Enumerator/Chain.html)**:
  ```ruby
  # Take data from several sources, abstracted into enumerator, fetching it on demand
  sources = URLS.lazy.map { |url| open(url).read }
    .chain(LOCAL_FILES.lazy.map { |path| File.read(path) })

  # ...then uniformly search several sources (lazy-loading them) for some value
  sources.detect { |body| body.include?('Ruby 2.6') }
  ```
* [2.6](2.6.md#filterfilter) `Enumerable#filter`/`#filter!` as alias for `#select`/`#select!` (as more familiar for users coming from other languages)
* [2.7](2.7.md#enumeratorproduce) **[Enumerator.produce](https://docs.ruby-lang.org/en/2.7.0/Enumerator.html#method-c-produce) to convert loops into enumerators**:
  ```ruby
  # Classic loop:
  date = Date.today
  date += 1 until date.monday?
  # With Enumerator.produce:
  Enumerator.produce(Date.today) { |date| date + 1 }.find(&:monday?)
  ```
* [2.7](2.7.md#enumerablefilter_map) [Enumerable#filter_map](https://ruby-doc.org/core-2.7.0/Enumerable.html#method-i-filter_map)
* [2.7](2.7.md#enumerabletally) [Enumerable#tally](https://ruby-doc.org/core-2.7.0/Enumerable.html#method-i-tally) method to count stats (hash of `{object => number of occurrences in the enumerable}`)
  * <span class="ruby-version">[3.1](3.1.md#enumerabletally-now-accepts-an-optional-hash-to-count)</span> [#tally](https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-tally) accepts an optional hash to append results to
* [2.7](2.7.md#enumeratorlazyeager) [Enumerator::Lazy#eager](https://ruby-doc.org/core-2.7.0/Enumerator/Lazy.html#method-i-eager)
* [2.7](2.7.md#enumeratoryielderto_proc) [Enumerator::Yielder#to_proc](https://ruby-doc.org/core-2.7.0/Enumerator/Yielder.html#method-i-to_proc)
* [3.1](3.1.md#enumerablecompact-and-enumeratorlazycompact) [Enumerable#compact](https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-compact)

<!--
* **2.3** `#chunk` and `#slice_before` no longer takes the `initial_state` argument
* [2.4](2.4.md#enumerablechunk-without-a-block-returns-an-enumerator) [Enumerable#chunk](https://ruby-doc.org/core-2.4.0/Enumerable.html#method-i-chunk) without a block returns an `Enumerator`
* [3.1](3.1.md#enumerableeach_cons-and-each_slice-return-a-receiver) `#each_cons` and `#each_slice` return a receiver ([Enumerable#each_cons](https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-each_cons), [Enumerable#each_slice](https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-each_slice))
* [3.1](3.1.md#enumerablecompact-and-enumeratorlazycompact) `Enumerator::Lazy#compact` ([Enumerable#compact](https://docs.ruby-lang.org/en/3.1/Enumerable.html#method-i-compact), [Enumerator::Lazy#compact](https://docs.ruby-lang.org/en/3.1/Enumerator/Lazy.html#method-i-compact))
-->

### `Range`

* [2.6](2.6.md#endless-range-1) **Endless range: `(1..)`**
* [2.6](2.6.md#range-uses-cover-instead-of-include) [#===](https://docs.ruby-lang.org/en/2.6.0/Range.html#method-i-3D-3D-3D) uses `#cover?` instead of `#include?` which means that ranges can be used in `case` and `grep` for any types, just checking if the value is between range ends:
  ```ruby
  case DateTime.now
  when Date.new(2022)..Date.new(2023)
    # wouldn't match in Ruby 2.5, would match in Ruby 2.6
  ```
* [2.6](2.6.md#rangecover-accepts-range-argument) [#cover?](https://docs.ruby-lang.org/en/2.6.0/Range.html#method-i-cover-3F) accepts range argument
* [2.7](2.7.md#beginless-range) **Beginless range: `(...100)`**

<!--
* [2.7](2.7.md#for-string) `#===` for `String` ([Range#===](https://ruby-doc.org/core-2.7.0/Range.html#method-i-3D-3D-3D))
* [2.7](2.7.md#minmax-implementation-change) `#minmax` implementation change ([Range#minmax](https://ruby-doc.org/core-2.7.0/Range.html#method-i-minmax))
-->

### `Array`

* **2.0** [#shuffle](https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-shuffle) and [#sample](https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-sample): `random:` optional parameter that accepts random number generator, will be called with `max` argument.
* **2.3** [#bsearch_index](https://docs.ruby-lang.org/en/2.3.0/Array.html#method-i-bsearch_index)
* [2.4](2.4.md#arrayconcat-takes-multiple-arguments) [#concat](https://ruby-doc.org/core-2.4.0/Array.html#method-i-concat) takes multiple arguments
* [2.4](2.4.md#arraypackbuffer) [#pack](https://ruby-doc.org/core-2.4.0/Array.html#method-i-pack): `buffer:` keyword argument to provide target
* [2.5](2.5.md#arrayappend-and-prepend) [#append](https://ruby-doc.org/core-2.5.0/Array.html#method-i-append) and [#prepend](https://ruby-doc.org/core-2.5.0/Array.html#method-i-prepend)
* [2.6](2.6.md#arrayunion-and-arraydifference) [#union](https://ruby-doc.org/core-2.6/Array.html#method-i-union) and [#difference](https://ruby-doc.org/core-2.6/Array.html#method-i-difference)
* [2.7](2.7.md#arrayintersection) [#intersection](https://ruby-doc.org/core-2.7.0/Array.html#method-i-intersection)
* [3.1](3.1.md#arrayintersect) [#intersect?](https://docs.ruby-lang.org/en/3.1/Array.html#method-i-intersect-3F)

<!--
* **2.0** [#values_at](https://docs.ruby-lang.org/en/2.0.0/Array.html#method-i-values_at) with Range argument returns `nil` for out-of-range indices
* [2.4](2.4.md#arraymax-and-min) [#max](https://ruby-doc.org/core-2.4.0/Array.html#method-i-max) and [#min](https://ruby-doc.org/core-2.4.0/Array.html#method-i-min)
* [3.0](3.0.md#array-always-returning-array) Always returning `Array` (—)
* [3.0](3.0.md#array-slicing-with-enumeratorarithmeticsequence) Slicing with `Enumerator::ArithmeticSequence` ([Array#[]](https://docs.ruby-lang.org/en/3.0.0/Array.html#method-i-5B-5D))
-->

### `Hash`

* **2.0** **Introduced convention of `#to_h` method** for explicit conversion to hashes, and added it to `Hash`, `nil`, and `Struct`;
  * <span class="ruby-version">**2.1**</span> [Array#to_h](https://docs.ruby-lang.org/en/2.1.0/Array.html#method-i-to_h) and [Enumerable#to_h](https://docs.ruby-lang.org/en/2.1.0/Enumerable.html#method-i-to_h) were added.
  * <span class="ruby-version">[2.6](2.6.md#to_h-with-a-block)</span> [#to_h](https://ruby-doc.org/core-2.6/Enumerable.html#method-i-to_h) accepts a block to define conversion logic:
  ```ruby
  users.to_h { |u| [u.name, u.admin?] } # => {"John" => false, "Jane" => true, "Josh" => false}
  ```
* **2.0** [Kernel#Hash](https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-Hash), invoking argument's `#to_hash` implicit conversion method, if it has one.
* **2.2** Change overriding policy for duplicated key: `{**hash1, **hash2}` contains values of `hash2` for duplicated keys.
* **2.2** Hash literal: Symbol key followed by a colon can be quoted, allowing code like `{"data-key": value}` or `{"#{prefix}_data": value}`.
* **2.3** [#fetch_values](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-fetch_values): a multi-key version of `#fetch`
* **2.3** [#<](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3C), [#>](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3E), [#<=](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3C-3D), [#>=](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-3E-3D) to check for inclusion of one hash in another.
* **2.3** [#to_proc](https://docs.ruby-lang.org/en/2.3.0/Hash.html#method-i-to_proc):
  ```ruby
  ATTRS = {first_name: 'John', last_name: 'Doe', gender: 'Male', age: 27}

  %i[first_name age].map(&ATTRS) # => ['John', 27]
  ```
* [2.4](2.4.md#hashcompact-and-compact) [#compact](https://ruby-doc.org/core-2.4.0/Hash.html#method-i-compact) and [#compact!](https://ruby-doc.org/core-2.4.0/Hash.html#method-i-compact-21) to drop `nil` values
* [2.4](2.4.md#hashtransform_values-and-transform_values) [#transform_values](https://ruby-doc.org/core-2.4.0/Hash.html#method-i-transform_values) and [#transform_values!](https://ruby-doc.org/core-2.4.0/Hash.html#method-i-transform_values-21)
* [2.5](2.5.md#hashtransform_keys-and-transform_keys) [#transform_keys](https://ruby-doc.org/core-2.5.0/Hash.html#method-i-transform_keys) and [#transform_keys!](https://ruby-doc.org/core-2.5.0/Hash.html#method-i-transform_keys-21)
* [2.5](2.5.md#hashslice) [#slice](https://ruby-doc.org/core-2.5.0/Hash.html#method-i-slice)
* [2.6](2.6.md#hashmerge-with-multiple-arguments) [#merge](https://ruby-doc.org/core-2.6/Hash.html#method-i-merge) supports multiple arguments
* [3.0](3.0.md#hashexcept) [#except](https://docs.ruby-lang.org/en/3.0.0/Hash.html#method-i-except)
* [3.0](3.0.md#hashtransform_keys-argument-for-key-renaming) [#transform_keys](https://docs.ruby-lang.org/en/3.0.0/Hash.html#method-i-transform_keys): argument for key renaming
  ```ruby
  {first: 'John', last: 'Doe'}.transform_keys(first: :first_name, last: :last_name)
  #=> {:first_name => 'John', :last_name => 'Doe'}
  ```
* [3.1](3.1.md#values-in-hash-literals-and-keyword-arguments-can-be-omitted) **Values in Hash literals [can be omitted](https://docs.ruby-lang.org/en/3.1/syntax/literals_rdoc.html#label-Hash+Literals)**:
  ```ruby
  x = 100
  y = 200
  {x:, y:}
  # => {x: 100, y: 200}, same as {x: x, y: y}
  ```

<!--
* [3.0](3.0.md#hasheach-consistently-yields-a-2-element-array-to-lambdas) `#each` consistently yields a 2-element array to lambdas (—)
-->

### `Set`

`Set` was a part of the standard library, but since Ruby 3.2 it will become part of Ruby core. A more efficient implementation (currently `Set` is implemented in Ruby, and stores data in `Hash` inside), and a separate set literal is up for discussion. That's why we list `Set`'s changes briefly here.

* **2.1** [#intersect?](https://docs.ruby-lang.org/en/2.1.0/Set.html#method-i-intersect-3F) and [#disjoint?](https://docs.ruby-lang.org/en/2.1.0/Set.html#method-i-disjoint-3F)
* **2.4** [#compare_by_identity](https://docs.ruby-lang.org/en/2.4.0/Set.html#method-i-compare_by_identity) and [#compare_by_identity?](https://docs.ruby-lang.org/en/2.4.0/Set.html#method-i-compare_by_identity-3F)
* **2.5** [#===](https://docs.ruby-lang.org/en/2.5.0/Set.html#method-i-3D-3D-3D) as alias to `#include?`, so `Set` can be used in `grep` and `case`:
  ```ruby
  file_list.grep(Set['README.md', 'License.txt']) # find an item that matches any of sets elements
  ```
* **2.5** [#reset](https://docs.ruby-lang.org/en/2.5.0/Set.html#method-i-reset)
* **3.0** `SortedSet` (that was a part of `set` standard library before) has been removed for dependency and performance reasons (it silently depended upon `rbtree` gem).
* **3.0** [#join](https://docs.ruby-lang.org/en/3.0/Set.html#method-i-join) is added as a shorthand for `.to_a.join`.
* **3.0** [#<=>](https://docs.ruby-lang.org/en/3.0/Set.html#method-i-3C-3D-3E) generic comparison operator (separate operators like `#<` or `#>` have been worked in previous versions, too)

<!--
* **2.5** `#to_s` as alias to `#inspect`
-->

### Other collections

* **2.0** [ObjectSpace::WeakMap](https://docs.ruby-lang.org/en/2.0.0/ObjectSpace/WeakMap.html) introduced
* **2.3** `Thread::Queue#close` is added to notice a termination
* [2.7](2.7.md#objectspaceweakmap-now-accepts-non-gc-able-objects) [ObjectSpace::WeakMap#[]=](https://ruby-doc.org/core-2.7.0/ObjectSpace/WeakMap.html#method-i-5B-5D-3D) now accepts non-GC-able objects
* [3.1](3.1.md#threadqueueinitialize-initial-values-can-be-passed-to-initializer) [Thread::Queue.new](https://docs.ruby-lang.org/en/3.1/Thread/Queue.html#method-c-new) allows initial queue content to be passed

## Filesystem and IO

* **2.1** [IO#seek](https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-seek) improvements: supports `SEEK_DATA` and `SEEK_HOLE`, and symbolic parameters (`:CUR`, `:END`, `:SET`, `:DATA`, `:HOLE`) for 2nd argument.
* **2.1** [IO#read_nonblock](https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-read_nonblock) and [#write_nonblock](https://docs.ruby-lang.org/en/2.1.0/IO.html#method-i-write_nonblock) accepts optional `exception: false` to return symbols
* **2.2** [Dir#fileno](https://docs.ruby-lang.org/en/2.2.0/Dir.html#method-i-fileno)
* **2.2** [File.birthtime](https://docs.ruby-lang.org/en/2.2.0/File.html#method-c-birthtime), [#birthtime](https://docs.ruby-lang.org/en/2.2.0/File.html#method-i-birthtime), and [File::Stat#birthtime](https://docs.ruby-lang.org/en/2.2.0/File/Stat.html#method-i-birthtime)
* **2.3** [File.mkfifo](https://docs.ruby-lang.org/en/2.3.0/File.html#method-c-mkfifo)
* **2.3** New [flags/constants](https://docs.ruby-lang.org/en/2.3.0/File/File/Constants.html) for IO opening: `File::TMPFILE` (open anonymous temp file) and `File::SHARE_DELETE` (open file that is allowed to delete)
* **2.3** [IO.new](https://docs.ruby-lang.org/en/2.3.0/IO.html#method-c-new): new keyword argument `flags:`
* [2.4](2.4.md#chomp-option-for-string-splitting) `chomp:` option for string splitting:
  ```ruby
  File.readlines("test.txt") # => ["foo\n", "bar\n", "baz\n"]
  File.readlines("test.txt", chomp: true) # => ["foo", "bar", "baz"]
  ```
* [2.4](2.4.md#empty-method-for-filesystem-objects) [Dir#empty?](https://ruby-doc.org/core-2.4.0/Dir.html#method-c-empty-3F), [File#empty?](https://ruby-doc.org/core-2.4.0/File.html#method-c-empty-3F), and [Pathname#empty?](https://ruby-doc.org/stdlib-2.4.0/libdoc/pathname/rdoc/Pathname.html#method-i-empty-3F)
* [2.5](2.5.md#iopread-and-pwrite) [IO#pread](https://ruby-doc.org/core-2.5.0/IO.html#method-i-pread) and [IO#pwrite](https://ruby-doc.org/core-2.5.0/IO.html#method-i-pwrite)
* [2.5](2.5.md#iowrite-accepts-multiple-arguments) [IO#write](https://ruby-doc.org/core-2.5.0/IO.html#method-i-write) accepts multiple arguments
* [2.5](2.5.md#fileopen-better-supports-newline-option) `File.open` better supports `newline:` option
* [2.5](2.5.md#filelutime) [File.lutime](https://ruby-doc.org/core-2.5.0/File.html#method-c-lutime)
* [2.5](2.5.md#dirchildren-and-each_child) [Dir.children](https://ruby-doc.org/core-2.5.0/Dir.html#method-c-children) and [.each_child](https://ruby-doc.org/core-2.5.0/Dir.html#method-c-each_child)
  * <span class="ruby-version">[2.6](2.6.md#direach_child-and-dirchildren)</span> [#children](https://ruby-doc.org/core-2.6/Dir.html#method-i-children) and [#each_child](https://ruby-doc.org/core-2.6/Dir.html#method-i-each_child) (instance method counterparts)
* [2.5](2.5.md#dirglob-base-argument) [Dir.glob](https://ruby-doc.org/core-2.5.0/Dir.html#method-c-glob): `base:` argument allows to provide a directory to look into instead of constructing a glob string including it.
* [2.6](2.6.md#io-open-mode-x) New [IO open mode](https://ruby-doc.org/core-2.6/IO.html#method-c-new-label-IO+Open+Mode) `'x'`: combined with `'w'` (open for writing), requests that file didn't exist before opening.
* [2.7](2.7.md#ioset_encoding_by_bom) [IO#set_encoding_by_bom](https://ruby-doc.org/core-2.7.0/IO.html#method-i-set_encoding_by_bom)
* [3.1](3.1.md#filedirname-optional-level-to-go-up-the-directory-tree) [File.dirname](https://docs.ruby-lang.org/en/3.1/File.html#method-c-dirname): optional `level` to go up the directory tree
* [3.1](3.1.md#iobuffer) **[IO::Buffer](https://docs.ruby-lang.org/en/3.1/IO/Buffer.html) low-level class introduced**

<!--
* **2.0** `File.fnmatch?` now expands braces in the pattern if File::FNM_EXTGLOB option is given.
* **2.0** `ARGF#codepoints` and `#each_codepoint`
* **2.2** `IO#read_nonblock` and `#write_nonblock` for pipes on Windows are supported.
* **2.3** `ARGF.read_nonblock` supports `exception: false` like IO#read_nonblock.
* [2.5](2.5.md#filepath-raises-when-opened-with-fileconstantstmpfile-option) [File#path](https://ruby-doc.org/core-2.5.0/File.html#method-c-path) raises when opened with `File::Constants::TMPFILE` option.
* [2.7](2.7.md#dirglob-and-dir-not-allow-0-separated-patterns) `Dir.glob` and `Dir.[]` not allow `\0`-separated patterns ([Dir.glob](https://ruby-doc.org/core-2.7.0/Dir.html#method-c-glob))
* [2.7](2.7.md#fileextname-returns-a--string-at-a-name-ending-with-a-dot) `File.extname` returns a `"."` string at a name ending with a dot. ([File.extname](https://bugs.ruby-lang.org/issues/15267))
* [3.0](3.0.md#dirglob-and-dir-result-sorting) `Dir.glob` and `Dir.[]` result sorting ([Dir.glob](https://docs.ruby-lang.org/en/3.0.0/Dir.html#method-c-glob))
-->

## Exceptions

This section covers exception raising/handling behavior changes, as well as changes in particular core exception classes.

* **2.0** [LoadError#path](https://docs.ruby-lang.org/en/2.0.0/LoadError.html) method to return the file name that could not be loaded.
* **2.1** [Exception#cause](https://docs.ruby-lang.org/en/2.1.0/Exception.html#method-i-cause) provides the previous exception which has been caught at where raising the new exception.
* **2.3** [NameError#receiver](https://docs.ruby-lang.org/en/2.3.0/NameError.html#method-i-receiver) stores an object in context of which the error have happened.
* **2.3** [NameError](https://docs.ruby-lang.org/en/2.3.0/NameError.html) and [NoMethodError](https://docs.ruby-lang.org/en/2.3.0/NoMethodError.html) suggest possible fixes with [did_you_mean](https://github.com/ruby/did_you_mean) gem:
  ```ruby
  'test'.szie
  # NoMethodError: undefined method `szie' for "test":String
  # Did you mean?  size
  ```
* [2.5](2.5.md#rescueelseensure-are-allowed-inside-blocks) **`rescue`/`else`/`ensure` are allowed inside blocks**:
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
* [2.5](2.5.md#exceptionfull_message) [Exception#full_message](https://ruby-doc.org/core-2.5.0/Exception.html#method-i-full_message)
* [2.5](2.5.md#keyerrorreceiver-and-key) [KeyError](https://ruby-doc.org/core-2.5.0/KeyError.html): `#receiver` and `#key` methods
* [2.5](2.5.md#new-class-frozenerror) New class: [FrozenError](https://ruby-doc.org/core-2.5.0/FrozenError.html)
* [2.5](2.5.md#dont-hide-coercion-errors) Don't hide coercion errors in `Numeric` and `Range` operations: raise original exception and not "can't be coerced" or "bad value for range"
* [2.6](2.6.md#else-in-exception-handling-context) `else` in exception-handling context without any `rescue` is prohibited.
* [2.6](2.6.md#numeric-methods-have-exception-argument) [#Integer()](https://ruby-doc.org/core-2.6/Kernel.html#method-i-Integer) and other similar conversion methods now have optional argument `exception: true/false`, defining whether to raise error on input that can't be converted or just return `nil`
* [2.6](2.6.md#system-has-exception-argument) [#system](https://ruby-doc.org/core-2.6/Kernel.html#method-i-system): optional argument `exception: true/false`
* [2.6](2.6.md#new-arguments-receiver-and-key) New arguments: `receiver:` for [NameError::new](https://ruby-doc.org/core-2.6/NameError.html#method-c-new) and [NoMethodError::new](https://ruby-doc.org/core-2.6/NoMethodError.html#method-c-new); `key:`  for [KeyError::new](https://ruby-doc.org/core-2.6/KeyError.html#method-c-new). It allows user code to construct errors with the same level of detail the language can.
* [2.6](2.6.md#exceptionfull_message-options) [Exception#full_message](https://ruby-doc.org/core-2.6/Exception.html#method-i-full_message): formatting options `highlight:` and `order:` added
* [2.7](2.7.md#frozenerror-receiver-argument) [FrozenError#new](https://ruby-doc.org/core-2.7.0/FrozenError.html#method-c-new): receiver argument
* [3.1](3.1.md#threadbacktracelimit) [Thread::Backtrace.limit](https://docs.ruby-lang.org/en/3.1/Thread/Backtrace.html#method-c-limit) reader to get the maximum backtrace size set with `--backtrace-limit` command-line option

<!--
* [2.5](2.5.md#backtrace-and-error-message-in-reverse-order) Backtrace and error message are (experimentally) displayed in a reverse order.
* [2.6](2.6.md#exception-output-tweaking) Exception output tweaking (—)
* [3.0](3.0.md#exception-output-order-is-changed----again) Exception output order is changed -- again (—)
-->

### Warnings

* **2.0** [Kernel#warn](https://docs.ruby-lang.org/en/2.0.0/Kernel.html#method-i-warn) accepts multiple args in like `#puts`.
* [2.4](2.4.md#warning-module) **[Warning](https://ruby-doc.org/core-2.5.0/Warning.html) module introduced**
* [2.5](2.5.md#warn-call-warningwarn) [Kernel#warn](https://ruby-doc.org/core-2.6/Kernel.html#method-i-warn) calls [Warning.warn](https://docs.ruby-lang.org/en/2.5.0/Warning.html#method-i-warn) internally
* [2.5](2.5.md#warn-uplevel-keyword-argument) [Kernel#warn](https://ruby-doc.org/core-2.6/Kernel.html#method-i-warn): `uplevel:` keyword argument allows to tune which line to specify in warning message as a source of warning
* [2.7](2.7.md#warning-and-) [Warning::[]](https://ruby-doc.org/core-2.7.0/Warning.html#method-c-5B-5D) and [Warning::[]=](https://ruby-doc.org/core-2.7.0/Warning.html#method-c-5B-5D-3D) to choose which categories of warnings to show; the categories are predefined by Ruby and only can be `:deprecated` or `:experimental` (or none)
  * <span class="ruby-version">[3.0](3.0.md#warningwarn-category-keyword-argument)</span> User code allowed to specify category of its warnings with [Kernel#warn](https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-warn) and intercept the warning category [Warning#warn](https://docs.ruby-lang.org/en/3.0.0/Warning.html#method-i-warn) with `category:` keyword argument; the list of categories is still closed.

## Concurrency and parallelism

### `Thread`

* **2.0** Concept of _thread variables_ introduced: methods [#thread_variable_get](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable_get), [#thread_variable_set](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable_set), [#thread_variables](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variables), [#thread_variable?](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-thread_variable-3F). Note that they are different from variables available via [Thread#[]](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-5B-5D), which are _fiber-local_.
* **2.0** [.handle_interrupt](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-c-handle_interrupt) to setup handling on exceptions and [.pending_interrupt?](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-c-pending_interrupt-3F)/[#pending_interrupt?](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-pending_interrupt-3F)
* **2.0** [#join](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-join) and [#value](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-value) now raises a `ThreadError` if target thread  is the current or main thread.
* **2.0** Thread-local [#backtrace_locations](https://docs.ruby-lang.org/en/2.0.0/Thread.html#method-i-backtrace_locations)
* **2.3** [#name](https://docs.ruby-lang.org/en/2.3.0/Thread.html#method-i-name) and [#name=](https://docs.ruby-lang.org/en/2.3.0/Thread.html#method-i-name-3D)
* [2.4](2.4.md#threadreport_on_exception-and-threadreport_on_exception) [.report_on_exception](https://ruby-doc.org/core-2.4.0/Thread.html#method-c-report_on_exception)/[.report_on_exception=](https://ruby-doc.org/core-2.4.0/Thread.html#method-c-report_on_exception-3D) and [#report_on_exception](https://ruby-doc.org/core-2.4.0/Thread.html#method-i-report_on_exception)/[#report_on_exception=](https://ruby-doc.org/core-2.4.0/Thread.html#method-i-report_on_exception-3D)
* [2.5](2.5.md#threadfetch) [#fetch](https://ruby-doc.org/core-2.6/Thread.html#method-i-fetch) is to `Thread#[]` like `Hash#fetch` is to `Hash#[]`: it allows to reliably get Fiber-local variable, raising or providing default value when it isn't defined
* [3.0](3.0.md#threadignore_deadlock-accessor) [.ignore_deadlock](https://docs.ruby-lang.org/en/3.0.0/Thread.html#method-c-ignore_deadlock)/[.ignore_deadlock=](https://docs.ruby-lang.org/en/3.0.0/Thread.html#method-c-ignore_deadlock-3D)
* [3.1](3.1.md#threadnative_thread_id) [#native_thread_id](https://docs.ruby-lang.org/en/3.1/Thread.html#method-i-native_thread_id)

### `Process`

* **2.0** [.getsid](https://docs.ruby-lang.org/en/2.0.0/Process.html#method-c-getsid) for getting session id (unix only).
* **2.1** [.argv0](https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-argv0) returns the original value of `$0`.
* **2.1** [.setproctitle](https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-setproctitle) sets the process title without affecting `$0`.
* **2.1** [.clock_gettime](https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-clock_gettime) and [.clock_getres](https://docs.ruby-lang.org/en/2.1.0/Process.html#method-c-clock_getres)
* [2.5](2.5.md#processlast_status-as-an-alias-of-) [Process.last_status](https://ruby-doc.org/core-2.5.0/Process.html#method-c-last_status) as an alias of `$?`
* [3.1](3.1.md#process_fork) [Process._fork](https://docs.ruby-lang.org/en/3.1/Process.html#method-c-_fork)

<!--
* **2.2** Process execution methods such as [.spawn](https://docs.ruby-lang.org/en/2.2.0/Process.html#method-c-spawn) opens the file in write  mode for redirect from `[:out, :err]`.
-->

### `Fiber`

* **2.0** [#resume](https://docs.ruby-lang.org/en/2.0.0/Fiber.html#method-i-resume) cannot resume a fiber which invokes [#transfer](https://docs.ruby-lang.org/en/2.0.0/Fiber.html#method-i-transfer).
* **2.2** `callcc` is obsolete, and `Fiber` should be used
* [2.7](2.7.md#fiberraise) [#raise](https://ruby-doc.org/core-2.7.0/Fiber.html#method-i-raise)
* [3.0](3.0.md#non-blocking-fiber-and-scheduler) **Non-blocking [Fiber](https://docs.ruby-lang.org/en/master/Fiber.html#class-Fiber-label-Non-blocking+Fibers) and [Fiber::SchedulerInterface](https://docs.ruby-lang.org/en/master/Fiber/SchedulerInterface.html)**. This is a big and important change, see [detailed explanation and code examples](3.0.md#non-blocking-fiber-and-scheduler) in 3.0's changelog. In brief, Ruby code now can perform non-blocking I/O concurrently from several fibers, with no code changes other than setting a _fiber scheduler_, which should be implemented by a third-party library.
  * [3.1](3.1.md#fiber-scheduler-new-hooks) New hooks for fiber scheduler: [#address_resolve](https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-address_resolve), [#timeout_after](https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-timeout_after), [#io_read](https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-io_read), and [#io_write](https://docs.ruby-lang.org/en/3.1/Fiber/SchedulerInterface.html#method-i-io_write)
* [3.0](3.0.md#fiberbacktrace--backtrace_locations) [#backtrace](https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-backtrace) and [#backtrace_locations](https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-backtrace_locations)

<!--
  * [3.0](3.0.md#fibertransfer-limitations-changed) `#transfer` limitations changed ([Fiber#transfer](https://docs.ruby-lang.org/en/3.0.0/Fiber.html#method-i-transfer))
-->

### `Ractor`

* [3.0](3.0.md#ractors) **[Ractors](https://docs.ruby-lang.org/en/3.0.0/Ractor.html) introduced.** A long-anticipated concurrency improvement landed in Ruby 3.0. Ractors (at some point known as Guilds) are fully-isolated (without sharing GVL on CRuby) alternative to threads. To achieve thread-safety without global locking, ractors, in general, can't access each other's (or main program/main ractor) data.
* [3.1](3.1.md#ractors-can-access-module-instance-variables) Ractors can access module instance variables

## Debugging and internals

* [2.6](2.6.md#rubyvmabstractsyntaxtree) **[RubyVM::AbstractSyntaxTree](https://ruby-doc.org/core-2.6/RubyVM/AbstractSyntaxTree.html) introduced**
* [2.6](2.6.md#rubyvmresolve_feature_path) `RubyVM.resolve_feature_path` introduced
  * <span class="ruby-version">[2.7](2.7.md#load_pathresolve_feature_path)</span> ...and was renamed to `$LOAD_PATH.resolve_feature_path`

<!--
* [2.7](2.7.md#resolve_feature_path-behavior-for-loaded-features-fixed) `$LOAD_PATH.resolve_feature_path` behavior for loaded features fixed
* [3.1](3.1.md#load_pathresolve_feature_path-does-not-raise) `$LOAD_PATH.resolve_feature_path` does not raise ([doc/globals.rdoc](https://docs.ruby-lang.org/en/3.1/globals_rdoc.html))
-->

### `Binding`

`Binding` object represents the execution context and allows to pass it around.

* **2.1** **[#local_variable_get](https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_get), [#local_variable_set](https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_set), [#local_variable_defined?](https://docs.ruby-lang.org/en/2.1.0/Binding.html#method-i-local_variable_defined-3F)**. Besides other things, it allows to use variables with names of Ruby reserved words:
  ```ruby
  def do_something(if:) # you can name argument this way, but can't refer to it in method's body by name
    condition = binding.local_variable_get('if')
    # ...use condition somehow
  end

  # The syntax might be useful for DSLs like
  validate :foo, if: -> { condition }
  ```
  * **2.2** [#local_variables](https://docs.ruby-lang.org/en/2.2.0/Binding.html#method-i-local_variables)
* **2.2** [#receiver](https://docs.ruby-lang.org/en/2.2.0/Binding.html#method-i-receiver)
* [2.6](2.6.md#bindingsource_location) [#source_location](https://ruby-doc.org/core-2.6/Binding.html#method-i-source_location)

### `GC`

_Note: in the spirit of the rest of this reference, this section only describes the changes in a garbage collector API, not changes of CRuby GC's algorithms._

* **2.0** [GC::Profiler.raw_data](https://docs.ruby-lang.org/en/2.0.0/GC/Profiler.html#method-c-raw_data)
* **2.2** [.latest_gc_info](https://docs.ruby-lang.org/en/2.2.0/GC.html#method-c-latest_gc_info) returns `:state` to represent current GC status.
* **2.2** Rename [.stat](https://docs.ruby-lang.org/en/2.0.0/GC.html#method-c-stat) entries
* [2.7](2.7.md#gccompact) [.compact](https://ruby-doc.org/core-2.7.0/GC.html#method-c-compact)
* [3.0](3.0.md#gcauto_compact-accessor) [.auto_compact](https://docs.ruby-lang.org/en/3.0.0/GC.html#method-c-auto_compact) and [.auto_compact=](https://docs.ruby-lang.org/en/3.0.0/GC.html#method-c-auto_compact-3D)
* [3.1](3.1.md#gc-measuring-total-time) Measuring total time spent in GC: [.measure_total_time](https://docs.ruby-lang.org/en/3.1/GC.html#method-c-measure_total_time), [.measure_total_time=](https://docs.ruby-lang.org/en/3.1/GC.html#method-c-measure_total_time-3D), [.stat](https://docs.ruby-lang.org/en/3.1/GC.html#method-c-stat) output updated, [.total_time](https://docs.ruby-lang.org/en/3.1/GC.html#method-c-total_time) added

<!--
* **2.1** introduced the generational GC a.k.a RGenGC.
* **2.2** Introduce incremental marking for major GC.
-->

### `TracePoint`

* **2.0** **[TracePoint](https://docs.ruby-lang.org/en/2.0.0/TracePoint.html) class is introduced: a fully object-oriented execution tracing API**; it is a replacement of the deprecated `set_trace_func`.
* [2.4](2.4.md#tracepointcallee_id) [#callee_id](https://ruby-doc.org/core-2.4.0/TracePoint.html#method-i-callee_id)
* [2.6](2.6.md#parameters) [#parameters](https://ruby-doc.org/core-2.6/TracePoint.html#method-i-parameters)
* [2.6](2.6.md#script_compiled-event) `:script_compiled` event ([TracePoint: Events](https://ruby-doc.org/core-2.6/TracePoint.html#class-TracePoint-label-Events) (though new event seems to be omitted), [TracePoint#instruction_sequence](https://ruby-doc.org/core-2.6/TracePoint.html#method-i-instruction_sequence), [TracePoint#eval_script](https://ruby-doc.org/core-2.6/TracePoint.html#method-i-eval_script))
* [2.6](2.6.md#enable-new-params-target-and-target_line) [#enable](https://ruby-doc.org/core-2.6/TracePoint.html#method-i-enable): new params `target:` and `target_line:`
* [3.1](3.1.md#tracepointallow_reentry) [.allow_reentry](https://docs.ruby-lang.org/en/3.1/TracePoint.html#method-c-allow_reentry)

### `RubyVM::InstructionSequence`

`InstructionSequence` is an API to interact with Ruby virtual machine bytecode. It is implementation-specific.

* **2.0** [.of](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-c-of) to get the instruction sequence from a method or a block.
* **2.0** [#path](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-path), [#absolute_path](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-absolute_path), [#label](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-label), [#base_label](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-base_label) and [#first_lineno](https://docs.ruby-lang.org/en/2.0.0/RubyVM/InstructionSequence.html#method-i-first_lineno) to retrieve information from where the instruction sequence was defined.
* **2.3** [#to_binary](https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-i-to_binary)
* **2.3** [.load_from_binary](https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-c-load_from_binary) and [.load_from_binary_extra_data](https://docs.ruby-lang.org/en/2.3.0/RubyVM/InstructionSequence.html#method-c-load_from_binary_extra_data)
* [2.5](2.5.md#rubyvminstructionsequence-new-methods) [#each_child](https://ruby-doc.org/core-2.5.0/RubyVM/InstructionSequence.html#method-i-each_child), [#trace_points](https://ruby-doc.org/core-2.5.0/RubyVM/InstructionSequence.html#method-i-trace_points)

<!--

* [2.5](2.5.md#misc) Misc (—)
* [2.6](2.6.md#misc) Language: Misc (—)
* [2.6](2.6.md#minor-changes) Minor changes (—)
* [2.7](2.7.md#other-syntax-changes) Language: Other syntax changes (—)
* [3.0](3.0.md#other-changes) Language changes: Other changes (—)

* [3.0](3.0.md#randomdefault-behavior-change) `Random::DEFAULT` behavior change ([Random](https://docs.ruby-lang.org/en/3.0.0/Random.html))

* [3.1](3.1.md#marshalload-accepts-a-freeze-option) `Marshal.load` accepts a `freeze:` option ([Marshal.load](https://docs.ruby-lang.org/en/3.1/Marshal.html#method-c-load))

-->

## Deeper topics

### Refinements

Refinements are hygienic replacement for reopening of classes and modules. They allow to add methods to objects on the fly, but unlike reopening classes (known as "monkey-patching" and frequently frowned upon), changes made by refinements are visible only in the file and module the refinement is used. As the adoption of refinements seems to be questionable, the details of their adjustments are put in a separate "deeper topics" section.

* **2.0** **Refinements are introduced as experimental feature** with [Module#refine](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-refine) and top-level `using`
* **2.1** [Module#refine](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-refine) and top-level `using` are no longer experimental
* **2.1** [Module#using](https://docs.ruby-lang.org/en/2.1.0/Module.html#method-i-using) introduced to activate refinements only in some particular module
* [2.4](2.4.md#refinements-are-supported-in-symbolto_proc-and-send) Refinements are supported in `Symbol#to_proc` and `send`
* [2.4](2.4.md#refine-can-refine-modules-too) [#refine](https://ruby-doc.org/core-2.4.0/Module.html#method-i-refine) can refine modules, too
* [2.4](2.4.md#moduleused_modules) [Module.used_modules](https://ruby-doc.org/core-2.4.0/Module.html#method-c-used_modules)
* [2.5](2.5.md#refinements-work-in-string-interpolations) Refinements work in string interpolations
* [2.6](2.6.md#refinements-improved-visibility) Refined methods are achievable with `#public_send` and `#respond_to?`, and implicit `#to_proc`.
* [2.7](2.7.md#refinements-in-methodinstance_method) Refined methods are achievable with `#method`/`#instance_method`
* [3.1](3.1.md#refinement-class) **[Refinement](https://docs.ruby-lang.org/en/3.1/Refinement.html) class** representing the `self` inside the `refine` statement. In particular, new method [#import_methods](https://docs.ruby-lang.org/en/3.1/Refinement.html#method-i-import_methods) became available inside `#refine` providing some (incomplete) remedy for inability to `#include` modules while refining some class.


### Freezing

Freezing of object makes its state immutable. The important thing about freezing core objects is it allows for many memory optimizations: any instance of the frozen string `"test"` can reference the same representation of the string in the memory.

* **2.0** Fixnums, Bignums and Floats are frozen. While number values never were mutable, before Ruby 2.0 it was possible to change additional internal state for them, making it weird:
  ```ruby
  10.instance_variable_set('@foo', 5) # works in 1.9, "can't modify frozen Fixnum" in 2.0
  10.instance_variable_set('@foo') # => 5 in Ruby 1.9
  ```
* **2.1** All symbols are frozen.
* **2.1** `"string_literal".freeze` is optimized to always return the same object for same literal
* **2.2** `nil`/`true`/`false` objects are frozen.
* **2.3** [String#+@](https://docs.ruby-lang.org/en/2.3.0/String.html#method-i-2B-40) and [#-@](https://docs.ruby-lang.org/en/2.3.0/String.html#method-i-2D-40) are added to get mutable/frozen strings.
  * _The methods are mnemonical to those using Celsius temperature scale, where 0 is freezing point, so any "minus-something" is frozen while "plus-something" is not._
* [2.4](2.4.md#objectclonefreeze-false) [Object#clone](https://ruby-doc.org/core-2.4.0/Object.html#method-i-clone): `freeze: false` argument to receive unfrozen clone of a frozen object
  * [3.0](3.0.md#objectclonefreeze-true) `freeze: true` also works, for consistency.
  * [3.0](3.0.md#objectclone-passes-freeze-argument-to-initialize_clone) `freeze:` argument is passed to `#initialize_clone`
* [2.7](2.7.md#core-methods-returning-frozen-strings) Several core methods like `nil.to_s` and `Module.name` return frozen strings
* [3.0](3.0.md#interpolated-string-literals-are-no-longer-frozen-when--frozen-string-literal-true-is-used) Interpolated String literals are no longer frozen when  [`# frozen-string-literal: true` pragma](https://docs.ruby-lang.org/en/3.0.0/syntax/comments_rdoc.html#label-frozen_string_literal+Directive) is used
* [3.0](3.0.md#regexp-and-range-objects-are-frozen) `Regexp` and `Range` objects are frozen
* [3.0](3.0.md#symbolname) [Symbol#name](https://docs.ruby-lang.org/en/3.0.0/Symbol.html#method-i-name) method that returns a frozen string equivalent of the symbol (`Symbol#to_s` returns mutable one, and changing it to be frozen would cause too much incompatibilities)

## Appendix: Covered Ruby versions release dates

* **2.0** — 2013, Feb 24
* **2.1** — 2013, Dec 25 (the same as every version after this)
* **2.2** — 2014
* **2.3** — 2015
* [2.4](/2.4.html) — 2016
* [2.5](/2.5.html) — 2017
* [2.6](/2.6.html) — 2018
* [2.7](/2.7.html) — 2019
* [3.0](/3.0.html) — 2020
* [3.1](/3.1.html) — 2021


