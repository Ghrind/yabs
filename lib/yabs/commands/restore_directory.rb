module Yabs
  class RestorePath < ConsoleApp::Command
    def initialize(vault, package, destination, options = {})
      @path = options[:path]
      @vault = vault
      @package = package
      @destination = destination
    end

    def run!
      # TODO: manage destination properly
      validate "Restore #{@path} from #{File.join(@package.directory)} to #{@destination}?"
      puts 'Restoring...'
      @package.restore(@destination, path: @path)
      puts 'Backup restored'
    end
  end
end
