# Yabs

A backup tool that fits my needs. And maybe yours. Or not.

## Features

### What I need:

* List what folders of this machine will be saved and where
* Backup the folders on a regular schedule
* Show the last backup information (date)
* Show the content of a backup
* Restore a full backup

### Nice to have

* Find a file through all backup versions
* Restore a single file
* List/restore what is saved on the server

## Installation

### Requiremnents

* duplicity
* python-paramiko (for ssh backup)

### Steps

* Install yabs
* Generate a GPG key (or use an existing one)
* Add the config file
* Make sure duplicity can connect through ssh (if needed)

## TODO

* Manage errors when duplicity command fails

## Resources

* https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu

## Usage

    yabs --help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ghrind/yabs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

