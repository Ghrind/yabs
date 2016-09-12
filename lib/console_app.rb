require 'fileutils'
require 'table_print'
require 'thor'

module ConsoleApp
  class OperationCancelled < StandardError
  end

  class BadConfigurationError < StandardError
  end

  class Commands < Thor
    def self.application=(app)
      @application = app
    end

    def self.application
      @application
    end

    private

    def app
      self.class.application
    end
  end

  # A generic console application
  class Application
    attr_reader :name, :version

    def initialize(name = 'console-app', version = '0.1.0')
      @name = name
      @version = version
    end

    def run(args)
      setup
      commands.start args, config
      0
    rescue BadConfigurationError
      1
    rescue OperationCancelled
      0
    end

    def commands
      return @_commands if @_commands
      commands_name = self.class.name.split('::')
      commands_name[-1] = 'Commands'
      @_commands = Kernel.const_get(commands_name.join('::'))
      @_commands.application = self
      @_commands
    end

    def config
      @_config ||= YAML.load_file(config_file('config.yml'))
    end

    def config_file(*args)
      File.join(config_dir, *args)
    end

    def config_dir
      File.expand_path("~/.#{name}")
    end

    def setup
      # Override this method with your application setup
    end

    def create_config_dir!
      FileUtils.mkdir_p(config_dir)
    end
  end

  class Command
    def self.run(*args)
      new(*args).run!
    end

    def initialize(*args)
      @args = args
      parse_options!
    end

    def run!
      fail 'Override this method with your action logic'
    end

    private

    def prompt_yes_no?(message)
      puts "#{message} (y/N)"
      char = $stdin.gets.chomp
      char.casecmp('y').zero?
    end

    def validate(message)
      unless prompt_yes_no?(message)
        puts 'Cancelling...'
        fail OperationCancelled
      end
    end
  end
end
