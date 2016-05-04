module Yabs
  class RestoreDirectory < ConsoleApp::Command
    def initialize(vault, package, destination)
      @vault = vault
      @package = package
      @destination = destination
    end

    def run!
      validate "Restore #{@package.directory} from #{@vault} to #{@destination} (y/N)?"
      puts 'Restoring...'
      @package.restore(@destination)
      puts 'Backup restored'
    end
  end
end
