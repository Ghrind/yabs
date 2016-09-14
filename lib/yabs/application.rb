require 'yaml'

module Yabs
  class Commands < ConsoleApp::Commands
    default_task :index

    desc 'index', 'List all local packages'
    def index
      ShowIndex.run app.vault, app.local_packages
    end

    desc 'log', 'Show the versions history of a single package'
    method_option :package, aliases: %w(-p), type: :string, default: '.'
    def log
      package = app.find_package(options[:package])
      ShowDirectoryHistory.run app.vault, package
    end

    desc 'show', 'List all files of a given version of a package'
    method_option :package, aliases: %w(-p), type: :string, default: '.'
    method_option :version, aliases: %W(-v), type: :string, default: 'last'
    def show
      package = app.find_package(options[:package])
      ShowDirectoryContent.run app.vault, package, version: options[:version]
    end

    desc 'restore', 'Restore a package/directory/file to the specified directory'
    method_option :package, aliases: %w(-p), type: :string, default: '.'
    method_option :destination, aliases: %w(-d), type: :string, required: true
    method_option :path, aliases: %w(-P), type: :string
    def restore
      package = app.find_package(options[:package])
      destination = File.expand_path(options[:destination])
      RestorePath.run app.vault, package, destination, path: options[:path]
    end

    desc 'backup', 'Backup all local packages to the vault'
    method_option :incremental, aliases: %w(-i), type: :boolean
    def backup
      # TODO: First backup should always be full
      type = options[:incremental] ? :incremental : :full
      BackupAllDirectories.run app.vault, app.local_packages, type
    end
  end

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

    def directories
      config['directories']
    end

    def hostname
      @_hostname ||= `hostname`.chomp
    end

    def find_package(reference)
      package = find_local_package(reference)
      package ||= Yabs::Package.new(reference, File.join(vault, reference))
      package
    end

    def find_local_package(reference)
      directory = File.expand_path(reference)
      local_packages.detect { |p| p.directory == directory }
    end

    def vault
      "#{config['vault']['scheme']}#{config['vault']['path']}"
    end

    def local_packages
      @_local_packages ||= directories.map do |directory|
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
      fail ConsoleApp::BadConfigurationError
    end

    def ensure_config_file
      return if File.exist?(config_file('config.yml'))
      puts CONFIG_HINT
      fail ConsoleApp::BadConfigurationError
    end

    def init_duplicity
      Duplicity.passphrase_path = config_file('passphrase')
    end
  end
end
