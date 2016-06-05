require "pathname"
require "erb"

class PluginRenderer
  class << self
    def render
      new.render
    end
  end

  def initialize
    @version = File.read("VERSION").strip

    path_query = Pathname.new(__FILE__).join("..", "lib", "**", "*.rb").expand_path
    @code = Pathname.glob(path_query).inject("") { |memo, path| memo + "\n" + path.read }

    @template = File.read(File.join("templates", "plugin.erb"))
  end

  attr_reader :version

  attr_reader :code

  def render
    ERB.new(@template).result(binding)
  end
end

task :build do
  data = PluginRenderer.render
  path = Pathname.new(__FILE__).join("..", "build", "bluetooth_inspector.10m.rb").expand_path

  path.dirname.mkpath
  path.open("w+") do |file|
    file.puts(data)
  end
end
