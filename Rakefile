require 'kramdown'
require 'yaml'
require 'ostruct'

require_relative '_src/lib/util'
require_relative '_src/lib/file'
require_relative '_src/lib/toc'
require_relative '_src/lib/render'

file '_data/book.yml' => FileList['_src/*.md'] do |t|
  puts "Rerendering TOC"
  chapters = TOC.(t.prerequisites)
  File.write(t.name, Util.deep_stringify_keys(chapters: chapters).to_yaml)
end

rule /^(\d+\.\d+|evolution)\.md$/ => ->(s) { "_src/#{s}" } do |t|
  from, to = t.prerequisites.first, t.name

  puts "Rendering #{from} => #{to}"
  File.write(to, Render.(from))
end

VERSIONS = [*('2.4'..'2.7'), *('3.0'..'3.4')]

desc 'Convert file contents from source to target (prettify)'
task contents: ['evolution', *VERSIONS].map(&'%s.md'.method(:%))

desc 'Render TOC for the changelog "book"'
task toc: '_data/book.yml'

task default: %i[toc contents]
