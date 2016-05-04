module Yabs
  class ShowDirectoryContent < ConsoleApp::Command
    def initialize(vault, package)
      @vault = vault
      @package = package
    end

    def run!
      version = @package.version(:last)

      puts "Package content for #{@package.directory} on #{@vault} (version: "\
           "#{version.index})"
      puts
      puts @package.content(:last)
    end
  end
end
