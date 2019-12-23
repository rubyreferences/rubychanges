require 'memoist'

class FileProcessor < Struct.new(:path)
  extend Memoist

  def self.call(path)
    new(path).call
  end

  private

  memoize def version
    path[%r{_src/(.+)\.md}, 1]
  end

  memoize def text
    File.read(path)
  end
end