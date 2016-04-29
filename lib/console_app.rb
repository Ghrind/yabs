require 'fileutils'
require 'table_print'

module ConsoleApp
  class OperationCancelled < StandardError
  end

  class BadConfigurationError < StandardError
  end

  # A generic console application
  class Application
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def run(args)
      @args = args
      run!
      0
    rescue BadConfigurationError
      1
    rescue OperationCancelled
      0
    end

    def run!
      fail 'Override this method with your application logic'
    end

    def config_file(*args)
      File.join(config_dir, *args)
    end

    def config_dir
      File.expand_path("~/.#{name}")
    end

    def setup
      fail 'Override this method with your application setup'
    end

    def create_config_dir!
      FileUtils.mkdir_p(config_dir)
    end
  end

  class Action
    def self.run(*args)
      new(*args).run!
    end

    def run!
      fail 'Override this method with your action logic'
    end

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
