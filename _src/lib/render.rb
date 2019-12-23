class Render < FileProcessor
  TRACKER_LINK_RE = %r{\[(?<kind>Bug|Feature|Misc) \#(?<num>\d+)\]\(https://bugs\.ruby-lang\.org/issues/(?<num2>\d+(\#.+)?)\)}

  def call
    text
      .gsub('<<date>>', File.mtime(path).strftime('%b %d, %Y'))
      .gsub(/\[(Bug|Feature|Misc) \#\d+\]\(.+?\)/, &method(:process_link))
      .gsub(
        %r{\[([^\[\]]+ [^\[\]]+)\]\((https://ruby-doc\.org.+?)\)},
        '<a class="ruby-doc" href="\\2">\\1</a>'
      )
      .gsub(
        %r{\[([^\[\]]+)\]\((https://ruby-doc\.org.+?)\)},
        '<a class="ruby-doc" href="\\2"><code>\\1</code></a>'
      )
      .gsub(%r{^\#{2,} (.+)$}) { |header| header + "[](##{Util.id(header)})" } # attach nice clickable links to headers
  end

  private

  def process_link(link)
    m = link.match(TRACKER_LINK_RE) or fail("Wrong link: #{link}")
    kind, num, num2 = m.values_at(:kind, :num, :num2)
    num == num2.sub(/\#.+$/, '') or fail "Wrong link: #{link}"
    %{<a class="tracker #{kind.downcase}" href="https://bugs.ruby-lang.org/issues/#{num2}">#{kind} ##{num}</a>}
  end
end