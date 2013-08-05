# KeepCalm

Simple gem for **pull backups**. Some of the code is based on the awesome [backup gem](https://github.com/meskyanichi/backup).

It was developed to suit our personal needs and backup strategy at [Diacode](http://diacode.com), where our **backup server uses SSH to dump MySQL databases and rsync the desired folders**.

With the approach the server that runs the app doesn't need to know anything about the backup process.


## Installation
The gem is not in RubyGems yet, therefore you'll need to clone the project and install the gem manually.

    $ git clone https://github.com/javiercr/keep_calm.git
    $ cd keep_calm
    $ bunddle
    $ rake install

## Requierements
* Your backup server (the one that runs the ruby backup script) needs to have SSH access to your app server. In other words, place the public key of the backup server into the `authorized_keys` file in the app server.

## Usage

Create a simple backup ruby script like the one below:

```ruby
require 'keep_calm'

backup = KeepCalm::Backup.new('/Users/javi/backups')

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
  s.folder do |f|
    f.key     = 'project2'
    f.path    = '/var/www/vhosts/project2/httpdocs/shared/uploads'
  end
end

backup.perform!
```

## TODO:
* Email notifications (WIP)
* PostgreSQL and MongoDB backups

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
