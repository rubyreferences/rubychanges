require 'date'

module TOC
  START_CHAPTERS = [
    {title: 'Introduction', path: '/'}
  ]
  FINAL_CHAPTERS = [
    {title: 'History (of this site)', path: '/History.html'},
    {title: 'Contributing', path: '/Contributing.html'}
  ]

  RSS_DESCRIPTION = <<~DESC
    **Highlights:**

    %s

    [Read more »](https://rubyreferences.github.io/rubychanges/%s.html)
  DESC

  def self.call(pathes)
    [
      *START_CHAPTERS,
      # Newest version is always on top
      *pathes.sort.reverse.map(&Item.method(:call)).flatten(1),
      *FINAL_CHAPTERS
    ]
  end

  class Item < FileProcessor
    def call
      doc.root.children
        .select { |c| c.type == :header }
        .map { |c|
          OpenStruct.new(
            level: c.options[:level],
            text: c.options[:raw_text],
            html: Util.inner_html(c)
          )
        }
        .then(&method(:nest_headers))
        .then { |nesting|
          toc_entries(nesting, "/#{version}.html", is_version: true, **rss_fields)
        }
    end

    private

    memoize def doc
      Kramdown::Document.new(text)
    end

    def toc_entries(nodes, prefix, **extra)
      nodes.map { |node|
        {
          title: node.html,
          path: node.level == 1 ? prefix : "#{prefix}##{Util.id(node.text)}",
          **(node.level == 1 ? extra : {}),
          children: toc_entries(node.children, prefix)
        }
        .tap { |h| h.delete(:children) if h[:children].empty? }
      }
    end

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

    def rss_fields
      return {} if version == 'evolution'

      pub = text[/\*\*This document first published:\*\* (.+)\n/, 1] or fail "Published at not found"
      desc = text[/\#\# Highlights\n(.+?)\n\#\# /m, 1] or fail "Description not found"
      desc = desc
        .gsub(/\[(.+?)\]\(.+?\)/, '\1') # remove links
        .then { |desc| RSS_DESCRIPTION % [desc, version] }
        .then(&Kramdown::Document.method(:new))
        .to_html

      {
        published_at: Date.parse(pub).strftime('%Y-%m-%d'),
        description: desc
      }
    end
  end
end
