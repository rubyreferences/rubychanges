# Used to prepare sources for evolution.md
# Obvously should be ported to Rake task and prettified but :shrug:

$LOAD_PATH.unshift '_src/lib/'
require 'kramdown'
require 'util'

files = [*('2.4'..'2.7'), *('3.0'..'3.4')].map(&'_src/%s.md'.method(:%))

list = []

files.each do |f|
  File.readlines(f, chomp: true).each do |ln|
    path = File.basename(f)
    version  = File.basename(f, '.md')
    case ln
    when %r{^(\#{2,}) (.+?)$}
      prefix, title = Regexp.last_match.captures
      cur = {version: version, file: path, level: prefix.length, title: title, id: Util.id(title)}
      if (section = list.reverse.find { _1[:level] < cur[:level] })
        cur[:nested] = section.values_at(:nested, :title).compact
        section[:section] = true
      end
      list << cur
    when %r{^\* \*\*Discussion:\*\* (.+)$}
      next if list.empty?
      list.last[:discussion]= Regexp.last_match[1]
    when %r{^\* \*\*Documentation:\*\* (.+)$}
      next if list.empty?
      list.last[:documentation]= Regexp.last_match[1]
    end
  end
end

DEFAULTS = {documentation: '—'}

IGNORE = [
  'Stdlib',
  'Standard library',
  'Highlights'
]

list.each { _1[:full_title] = _1.values_at(:nested, :title).flatten.compact.join(': ') }
list.reject! { _1.values_at(:title, :nested).flatten.intersect?(IGNORE) || _1[:section] }

known = File.read('_src/evolution.md').scan(/\[(\d\.\d)\]\(\1\.md#(.+?)\)/m)

list.reject! { known.include?(_1.values_at(:version, :id)) }

puts(list.map { |row|
  '* [%{version}](%{file}#%{id}) %{full_title} (%{documentation})' % DEFAULTS.merge(row)
}.join("\n"))
