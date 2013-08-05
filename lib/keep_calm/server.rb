module KeepCalm
  class Server
    
    ## 
    # Host or IP for SSH
    attr_accessor :host

    ## 
    # User for SSH
    attr_accessor :user

    ##
    # Array of database objects
    attr_accessor :databases
    
    ##
    # Array of folders objects
    attr_accessor :folders
    
    ##
    # Reference to backup object
    attr_reader :backup

    def initialize(backup, &block)
      @backup = backup
      @databases = []
      @folders = []
      instance_eval(&block) if block_given?
    end

    ##
    # Adds a Database to the databases array
    def database(&block)
      @databases << Database.new(self, &block)
    end


    ##
    # Adds a folder to the folders array
    def folder(&block)
      @folders << Folder.new(self, &block)
    end


    ##
    # Performs the backup of databases and folders
    def backup!
      @databases.each {|db| db.backup! }
      @folders.each {|f| f.backup! }
    end


    def storage_databases_path
      backup.storage_databases_path
    end

    def storage_folders_path
      backup.storage_folders_path
    end

    def log(msg)
      backup.log(msg)
    end
  end
end
