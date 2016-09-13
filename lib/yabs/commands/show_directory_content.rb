module Yabs
  class ShowDirectoryContent < ConsoleApp::Command
    DEFAULT_OPTIONS = {
      version: :last
    }.freeze

    def initialize(vault, package, options = {})
      @vault = vault
      @package = package
      options = DEFAULT_OPTIONS.merge(options)
      @version = options[:version]
    end

    def run!
      version = @package.version(@version)

      puts "Package content for #{@package.directory} on #{@vault} (version: "\
           "#{version.index})"
      puts
      puts @package.content(@version)
    end
  end
end
