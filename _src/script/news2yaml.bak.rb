section = []

stream = []

lines = File.read('2.6/NEWS').split("\n")
$registry = []

def Cls(*symbols)
  Struct.new(*symbols) do
    def initialize(*)
      super
      $registry.push(self)
    end
  end
end

Section = Cls(:title, :level)
Def     = Cls(:text, :definition)
Li      = Cls(:content)
Text    = Cls(:text)
Code    = Cls(:text)
Empty   = Cls(:empty)
# def Empty.new
#   $registry << self
# end

def read_indented(lines, indent = 0)
  stream = []
  indent_re = /^ {#{indent}}/

  while !lines.empty? && (lines.first.empty? || lines.first.match?(indent_re))
    ln = lines.shift.sub(indent_re, '')

    case ln
    when '# -*- rdoc -*-'
      # skip
    when /^= /
      # skip, first header
    when /^(=+) (.+)$/
      level = $1.length - 2
      title = $2
      stream << Section.new(title, level)
    when /^\[(.+)\]$/
      # if it was no empty line before, it is just accidental, like this:
      # * foo bar
      #   [experimental]
      if $registry.empty? || $registry.last.is_a?(Empty)
        text = $1
        lines.shift while lines.first.empty? && !lines.empty?
        # p [text, lines.first]
        # p [text, $registry.last(3)]
        # should always be +2, but in reality, Ruby 2.6 NEWS in [Regexp/String] section has 4
        # ...and other sections have 0
        plus_indent = lines.first.sub(indent_re, '')[/^ */].length
        definition = read_indented(lines, indent + plus_indent)
        stream << Def.new(text, definition)
      else
        stream << Text.new(ln)
      end
    when /^\* (.+)$/
      start = $1
      rest = read_indented(lines, indent + 2)
      stream.push(Li.new([Text.new(start), *rest]))
    when /^  (.+)$/
      start = $1
      rest = []
      indent_code_re = /^ {#{indent + 2}}/
      rest << lines.shift.sub(indent_code_re, '') while !lines.empty? && lines.first.match?(indent_code_re)
      stream << Code.new([start, *rest].join("\n"))
    when /^\s*$/
      stream << Empty.new
    else
      stream << Text.new(ln)
    end
  end

  stream
end

res = read_indented(lines)

# flatten into:
# {section: ... (sec, def), text: ...}