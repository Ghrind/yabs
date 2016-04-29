require 'yaml'

module Yabs
  # The yabs console application
  class Application < ConsoleApp::Application
    PASSPHRASE_HINT = 'Yabs needs a duplicity GPG signature passphrase file to'\
                      " work properly.\n\n"\
                      'Please create an hidden file with your gpg key '\
                      "passphrase.\n\n"\
                      "     echo 'My Passphrase' > "\
                      "%{file_path}\n"\
                      '     chmod 600 %{file_path}'.freeze

    # TODO: Makes this better
    CONFIG_HINT = 'Please create the configuration file'.freeze

    # log: 'ShowDirectoryHistory',
    # show: 'ShowDirectoryContent'

    DEFAULT_ACTION = 'index'.freeze

    def config
      @_config ||= YAML.load_file(config_file('config.yml'))
    end

    def directories
      config['directories']
    end

    def vault
      "#{config['vault']['scheme']}#{config['vault']['path']}"
    end

    def hostname
      @_hostname ||= `hostname`.chomp
    end

    def find_package(directory)
      directory = File.expand_path(directory)
      packages.detect { |p| p.directory == directory }.tap do |package|
        fail "No package found for '#{directory}'" unless package
      end
    end

    def packages
      @_packages ||= directories.map do |directory|
        remote = File.join(vault, hostname, directory)
        Yabs::Package.new directory, remote
      end
    end

    def setup
      # Yabs won't do anything without a bit of config
      create_config_dir!
      ensure_passphrase_file
      ensure_config_file
      init_duplicity
    end

    def ensure_passphrase_file
      return if File.exist?(config_file('passphrase'))
      puts PASSPHRASE_HINT.gsub('%{file_path}', config_file('passphrase'))
      fail ApplicationExit
    end

    def ensure_config_file
      return if File.exist?(config_file('config.yml'))
      puts CONFIG_HINT
      fail ApplicationExit
    end

    def init_duplicity
      Duplicity.passphrase_path = config_file('passphrase')
    end

    def run!
      setup
      run_action @args.first
    end

    def run_action(action_name)
      case (action_name || DEFAULT_ACTION)
      when 'restore'
        package = find_package(@args[1] || '.')
        fail 'You must provide a destination' unless @args[2]
        destination = File.expand_path(@args[2])
        Commands::RestoreDirectory.run vault, package, destination
      when 'log'
        package = find_package(@args[1] || '.')
        Commands::ShowDirectoryHistory.run vault, package
      when 'show'
        package = find_package(@args[1] || '.')
        Commands::ShowDirectoryContent.run vault, package
      when 'backup'
        # TODO: First backup should always be full
        type = @args[1]
        Commands::BackupAllDirectories.run vault, packages, type
      when 'index'
        Commands::ShowIndex.run vault, packages
      else
        puts "Command not recognized: #{action_name}"
      end
    end
  end
end
