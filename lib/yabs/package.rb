require_relative 'package_version'

module Yabs
  # Wraps all operation available on a backuped directory
  class Package
    attr_reader :directory

    def initialize(directory, remote)
      # TODO: Manage the GPG key option
      @encrypt_key = '8D5814C8'
      @directory = directory
      @remote = remote
    end

    # type may be full or incremental
    def backup(type = 'incremental')
      duplicity type, '--encrypt-key', @encrypt_key, @directory, @remote
    end

    def restore(destination, options = {})
      args = []
      if options[:path]
        args << '--file-to-restore'
        args << options[:path]
      end
      duplicity 'restore', *args, @remote, destination
    end

    def versions
      versions = []
      output = duplicity('collection-status', @remote)
      i = 0
      output.each_line do |line|
        next unless line =~ /^ *(Full|Incremental)/
        versions << PackageVersion.parse(line, i)
        i = i.next
      end
      versions
    end

    def version(version_index)
      all_versions = versions
      if all_versions.respond_to?(version_index)
        all_versions.send(version_index)
      else
        all_versions[version_index.to_i]
      end
    end

    def content(version_index)
      v = version(version_index)
      duplicity 'list-current-files',
                '-t', v.timestamp.strftime('%Y-%m-%dT%H:%M:%S'),
                @remote
    end

    private

    def duplicity(*args)
      Duplicity.run(*args)
    end
  end
end
