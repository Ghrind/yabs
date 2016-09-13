require 'shellwords'
require 'command'

# A wrapper arround the duplicity binary
module Duplicity

  class DuplicityError < RuntimeError
  end

  BINARY = 'duplicity'.freeze

  def self.verbose
    false
  end

  def self.passphrase_path=(path)
    @passphrase_path = path
  end

  def self.passphrase_path
    @passphrase_path
  end

  def self.run(*args)
    command = escape([BINARY] + args).join(' ')
    puts '--- ' + command if verbose
    r = run_command_with_passphrase(command)
    log_result(r) if verbose
    raise DuplicityError, r.stderr unless r.status.zero?
    r.stdout
  end

  def self.escape(words)
    words.map { |w| Shellwords.escape(w) }
  end

  def self.passphrase
    Shellwords.escape(File.read(passphrase_path))
  end

  def self.run_command_with_passphrase(command)
    command = "PASSPHRASE=#{passphrase} #{command}"
    Command.run(command)
  end

  def self.log_result(result)
    puts '=== out'
    puts result.stdout
    puts '--- err'
    puts result.stderr
    puts '--- status'
    puts result.status
    puts '==='
  end
end
