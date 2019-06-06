# FIXME: Maybe it is reasonable to parse it with Kramdown and render back with
# Kramdown::Converter::Markdown, but for now, regexp-s seem to be enough, and
# proper "re-rendering" sometimes produces some pretty weird side effects.

# It is Kramdown::Base#basic_generate_id
def id(str)
  gen_id = str.gsub(/^[^a-zA-Z]+/, '')
  gen_id.tr!('^_a-zA-Z0-9 -', '')
  gen_id.tr!(' ', '-')
  gen_id.downcase!
  gen_id
end

Dir['_src/*.md'].grep(/\d/).sort.each do |path|
  ver = path.scan(%r{_src/(.+)\.md}).flatten.first

  srcpath = File.expand_path("../#{ver}.md", __dir__)
  dstpath = File.expand_path("../../#{ver}.md", __dir__)

  File.read(srcpath)
    .gsub(/\[(Bug|Feature|Misc) \#\d+\]\(.+?\)/) { |link|
      m = link.match(%r{\[(?<kind>Bug|Feature|Misc) \#(?<num>\d+)\]\(https://bugs\.ruby-lang\.org/issues/(?<num2>\d+)\)}) or fail("Wrong link: #{link}")
      m[:num] == m[:num2] or fail "Wrong link: #{link}"
      kind, num = m.values_at(:kind, :num)
      %{<a class="tracker #{kind.downcase}" href="https://bugs.ruby-lang.org/issues/#{num}">#{kind} ##{num}</a>}
    }
    .gsub(%r{\[([^\[\]]+ [^\[\]]+)\]\((https://ruby-doc\.org.+?)\)}, '<a class="ruby-doc" href="\\2">\\1</a>')
    .gsub(%r{\[([^\[\]]+)\]\((https://ruby-doc\.org.+?)\)}, '<a class="ruby-doc" href="\\2"><code>\\1</code></a>')
    .gsub(%r{^\#{2,} (.+)$}) { |header|
      header + "[](##{id(header)})"
    }
    .tap(&File.open(dstpath, 'w').method(:write))
end