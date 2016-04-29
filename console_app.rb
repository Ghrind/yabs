require 'shellwords'
require 'command'
require 'fileutils'

module ConsoleApp
  class Application
    class ApplicationExit < StandardError
    end

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def run
      run!
      0
    rescue ApplicationExit
      1
    end

    def run!
      fail 'Override this method with your application setup'
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
end
