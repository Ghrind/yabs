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
    end
  end
end
