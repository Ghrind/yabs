module Yabs
  module Commands
    # Backup all local packages
    class BackupAllDirectories < ConsoleApp::Action
      def initialize(vault, packages, type)
        @vault = vault
        @packages = packages
        @type = type
      end

      def run!
        @packages.each do |p|
          puts "- #{p.directory}"
        end
        puts
        validate "Backup those packages to #{@vault}?"

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
