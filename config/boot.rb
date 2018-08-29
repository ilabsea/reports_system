ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'yaml'

module Options
  extend self

  CONFIG = YAML.load_file(File.expand_path('../settings.yml', __FILE__))

  def is_on?(plugin)
    plugins[plugin.to_s] == true
  end

  def selected_plugins
    plugins.map{|k,v| k if v == true }.compact
  end

  def method_missing(method_name)
    if method_name.to_s =~ /(\w+)\?$/
      CONFIG[$1] == true
    else
      CONFIG[method_name.to_s]
    end
  end
end