module Yabs
  module Commands
    class RestoreDirectory
      def self.run(vault, package, destination)
        new(vault, package, destination).run!
      end

      def initialize(vault, package, destination)
        @vault = vault
        @package = package
        @destination = destination
      end

      def run!
        puts "Restore #{@package.directory} from #{@vault} to #{@destination} (y/N)?"
        char = $stdin.gets.chomp
        unless char.casecmp('y').zero?
          puts 'Cancelling...'
          exit
        end
        puts 'Restoring...'
        @package.restore(@destination)
        puts 'Backup restored'
      end
    end
  end
end
