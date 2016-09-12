module Yabs
  # Backup all local packages
  class BackupAllDirectories < ConsoleApp::Command
    def initialize(vault, packages, type)
      @vault = vault
      @packages = packages
      @type = type || 'incremental'
    end

    def run!
      @packages.each do |p|
        puts "- #{p.directory}"
      end
      puts
      validate "Backup (#{@type}) those packages to #{@vault}?"

      puts "Backuping (#{@type})..."
      @packages.each do |p|
        puts "#{p.directory}..."
        p.backup @type
      end
      puts 'Backup completed'
    end
  end
end
