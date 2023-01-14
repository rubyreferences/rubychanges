class Render < FileProcessor
  TRACKER_LINK_RE = %r{\[(?<kind>Bug|Feature|Misc) \#(?<num>\d+)(?<note>\#note-\d+)?\]\(https://bugs\.ruby-lang\.org/issues/(?<num2>\d+(\#.+)?)(\#note-\d+)?\)}
  DOC_URLS = '(?:https://ruby-doc\.org|https://docs.ruby-lang.org)'

  def call
    text
      .gsub('<<date>>', File.mtime(path).strftime('%b %d, %Y'))
      .gsub(/\[(Bug|Feature|Misc) \#\d+.*?\]\(.+?\)/, &method(:process_link))
      .gsub( # links to official docs to just nicer links (with icon)
        %r{\[([^\[\]]+ [^\[\]]+)\]\((#{DOC_URLS}.+?)\)},
        '<a class="ruby-doc" href="\\2">\\1</a>'
      )
      .gsub( # links without spaces are typically class/method names, so wrapped in <code>
        %r{\[(\S+?)\]\((#{DOC_URLS}.+?)\)},
        '<a class="ruby-doc" href="\\2"><code>\\1</code></a>'
      )
      .gsub(
        %r{\[(\S+)\]\((https://github\.com.+?)\)},
        '<a class="github" href="\\2">\\1</a>'
      )
      .gsub(%r{^\#{2,} (.+)$}) { |header| header + "[](##{Util.id(header)})" } # attach nice clickable links to headers
      .then {
        next _1 unless version == 'evolution'

        _1.gsub(/^(\s*)\* (\*\*\d\.\d\*\*|\[\d\.\d\]\(.+?\))/, '\1* <span class="ruby-version">\2</span>')
      }
  end

  private

  def process_link(link)
    m = link.match(TRACKER_LINK_RE) or fail("Wrong link: #{link}")
    kind, num, num2, note = m.values_at(:kind, :num, :num2, :note)
    num == num2.sub(/\#.+$/, '') or fail "Wrong link: #{link}"
    note_render = "<small>#{note}</small>" if note
    %{<a class="tracker #{kind.downcase}" href="https://bugs.ruby-lang.org/issues/#{num2}#{note}">#{kind} ##{num}#{note_render}</a>}
  end
end
