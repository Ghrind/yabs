require 'time'

module Yabs
  # A version of a duplicity backup
  class PackageVersion
    attr_reader :type, :timestamp, :index

    def self.parse(row, index)
      parts = row.split(/ +/)
      parts.shift if parts.first == ''
      type = parts[0]
      parts.pop # Nb volumes
      time = parts.join(' ')
      timestamp = Time.parse(time)
      new index, type, timestamp
    end

    def self.blank
      new '-', '-', 'Never'
    end

    def initialize(index, type, timestamp)
      @index = index
      @type = type
      @timestamp = timestamp
    end
  end
end
