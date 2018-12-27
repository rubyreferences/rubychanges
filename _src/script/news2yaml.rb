require 'rdoc'
require 'yaml'

include RDoc
doc = Markup::Parser.parse(File.read('2.6/NEWS').sub(/("target_line:".)\s+/, '\1 '))
parts = doc.parts.dup
# skip Intro
parts.shift until parts.first.is_a?(Markup::Heading) && parts.first.level == 3

current_section = []

$res = []

def process_item(item, *nesting)
  if item.label
    item.parts.grep_v(Markup::BlankLine)
      .each do |part|
        case part
        when Markup::List
          part.items.each { |i| process_item(i, *nesting, item.label) }
        when Markup::Paragraph
          $res << {item: Markup::Document.new(part), section: [*nesting, item.label]}
        else
          fail "Unexpected nesting: #{part}"
        end
      end
  else
    $res << {item: Markup::Document.new(*item.parts), section: nesting}
  end
end

parts.each do |node|
  case node
  when Markup::BlankLine
  when Markup::Heading
    l = node.level - 3
    current_section[l] = node.text
    current_section.slice!(l+1)
  when Markup::List
    node.items.each { |i| process_item(i, *current_section) }
  else
    fail "Unexpected #{node.inspect}"
  end
end

def to_markdown(item)
  conv = Markup::ToMarkdown.new
  item.accept(conv)
end

$res.map { |item:, section:|
  md = to_markdown(item).rstrip.gsub(/\n(?![ \n\*])/, ' ')
  {
    section: section.flatten, # FIXME?
    ticket: md.scan(/\[((?:Misc|Bug|Feature)\s+\#\d+)\]/).flatten.first&.tr("\n", ' ') || 'none',
    md: md,
    target: nil
  }
}
.group_by { |ticket:, **| ticket }.values.flatten # FIXME #chunk or what
.map { |r| r.transform_keys(&:to_s) }
# .tap { |res| File.write('2.6/news.yml', res.to_yaml(line_width: 200)) }