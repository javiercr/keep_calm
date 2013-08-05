module StayCalm
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


    def backup!
      @databases.each {|db| db.backup! }
      @folders.each {|f| f.backup! }
    end

    ##
    # Backups the specified folders using rsync
    # def backup_folders
    #   ssh =  "#{@user}@#{@host}"
    #   @folders.each do |folder|
    #     src = "#{ssh}:#{folder[:path]}"
    #     dest = File.join(@storage_path, "folders", folder[:key])
    #     FileUtils.mkdir_p dest
    #     command = "rsync #{src} #{dest} -a"
    #     log "Rsync #{folder[:path]}"
    #     p command
    #     system(command)
    #   end

    # rescue Exception => err
    #   @exception = err

    # ensure
    #   log(@exception)
    # end



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
