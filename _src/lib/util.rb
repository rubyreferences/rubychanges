module Util
  extend self

  HTML = Kramdown::Converter::Html

  def deep_stringify_keys(hash)
    _stringify_keys_any(hash)
  end

  # It is Kramdown::Base#basic_generate_id
  def id(str)
    str.gsub(/^[^a-zA-Z]+/, '')
       .tr('^_a-zA-Z0-9 -', '')
       .tr(' ', '-')
       .downcase
  end

  def inner_html(h)
    h.options[:encoding] = 'UTF-8'
    h.type = :root
    HTML.convert(h).first
  end

  private

  def _stringify_keys_any(v)
    case v
    when Hash  then v.to_h { |k, v| [k.to_s, _stringify_keys_any(v)] }
    when Array then v.map(&method(:_stringify_keys_any))
    else v
    end
  end
end
