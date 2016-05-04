module Yabs
  class ShowIndex < ConsoleApp::Command
    def initialize(vault, packages)
      @vault = vault
      @packages = packages
    end

    def run!
      # TODO: This seems to create distant folder (which are useless)
      # List all local packages
      puts 'Local packages'
      puts
      puts "Backup store: #{@vault}"
      puts
      content = @packages.map do |p|
        v = p.version(:last) || Yabs::PackageVersion.blank
        {
          folder: p.directory,
          version: v.index,
          last_backup: v.timestamp
        }
      end
      tp content
      puts
      puts 'Hint: Version numbering starts at 0.'
    end
  end
end
