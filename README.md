# StayCalm

Simple gem for **pull backups**. Some of the code is based on the awesome [Backup gem](https://github.com/meskyanichi/backup).

It was developed to suit our personal needs and backup strategy at [Diacode](http://diacode.com), where our **backup server uses SSH to dump MySQL databases and rysnc the desired folders**

## Installation

    $ gem install stay_calm

## Usage

Create a simple ruby script like the one below:

```ruby
require 'stay_calm'

backup = StayCalm::Backup.new('/Users/javi/backups')

backup.server do |s|
  s.user        = 'myuser'
  s.host        = 'myhost.com'

  # Databases to backup in this server  
  databases = ['database_name_1', 'database_name_2',]
  databases.each do |db_name|
    s.database do |db|
      db.name = db_name
      db.user = 'my_db_user' 
      db.password = 'my_db_password' 
    end
  end

  # Folders to backup in this server
  s.folder do |f|
    f.key     = 'project1' # will be used for naming the backup folder
    f.path    = '/var/www/vhosts/project1/httpdocs/shared/uploads'
  end
end

backup.perform!
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
