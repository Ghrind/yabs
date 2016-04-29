module Yabs
  module Commands
    class BackupAllDirectories
      def self.run(vault, packages, type)
        new(vault, packages, type).run!
      end

      def initialize(vault, packages, type)
        @vault = vault
        @packages = packages
        @type = type
      end

      def run!
        # Backup all local packages
        @packages.each do |p|
          puts "- #{p.directory}"
        end
        puts
        puts "Backup those packages to #{@vault} (y/N)?"
        char = $stdin.gets.chomp
        unless char.casecmp('y').zero?
          puts 'Cancelling...'
          exit
        end
        puts 'Backuping...'
        @packages.each do |p|
          puts "#{p.directory}..."
          p.backup @type
        end
        puts 'Backup completed'
      end
    end
  end
end
