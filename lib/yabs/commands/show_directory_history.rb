module Yabs
  class ShowDirectoryHistory < ConsoleApp::Command
    def initialize(vault, package)
      @vault = vault
      @package = package
    end

    def run!
      puts "Package versions for #{@package.directory} on #{@vault}"
      puts
      @package.versions.each do |version|
        puts "[#{version.index}] #{version.timestamp} (#{version.type})"
      end
    end
  end
end
