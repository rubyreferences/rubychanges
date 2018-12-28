require 'kramdown'
require 'yaml'
require 'ostruct'

chapters = [
  {title: 'Introduction', path: '/'}
]

doc = Kramdown::Document.new(File.read('_src/2.6.md'))

HTML = Kramdown::Converter::Html

def inner_html(h)
  h.options[:encoding] = 'UTF-8'
  h.type = :root
  HTML.convert(h).first
end

headers = doc.root.children.select { |c| c.type == :header }
  .map { |c| OpenStruct.new(level: c.options[:level], text: c.options[:raw_text], html: inner_html(c)) }

def nest_headers(headers, level = 1)
  res = []
  while !headers.empty? && headers.first.level == level
    cur = headers.shift
    children = nest_headers(headers, level + 1)
    cur.children = children
    res << cur
  end
  res
end

# It is Kramdown::Base#basic_generate_id
def id(str)
  gen_id = str.gsub(/^[^a-zA-Z]+/, '')
  gen_id.tr!('^_a-zA-Z0-9 -', '')
  gen_id.tr!(' ', '-')
  gen_id.downcase!
  gen_id
end

def toc_entries(nodes, prefix)
  nodes.map do |node|
    {
      title: node.html,
      path: "#{prefix}##{id(node.text)}",
      children: toc_entries(node.children, prefix)
    }.tap { |h| h.delete(:children) if h[:children].empty? }
  end
end

class Hash
  def deep_stringify_keys
    _stringify_keys_any(self)
  end

  def _stringify_keys_any(v)
    case v
    when Hash
      v.map { |k, v| [k.to_s, _stringify_keys_any(v)] }.to_h
    when Array
      v.map(&method(:_stringify_keys_any))
    else
      v
    end
  end
end

# h = headers.detect { |h| h.html.include?('with a block') }
# p h, id(h.text)

nesting = nest_headers(headers)

chapters.concat(toc_entries(nesting, '/2.6.html'))
chapters << {title: 'Contributing', path: '/Contributing.html'}

File.write('_data/book.yml', {chapters: chapters}.deep_stringify_keys.to_yaml)