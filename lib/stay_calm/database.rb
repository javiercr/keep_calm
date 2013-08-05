module KeepCalm
  class Database

    attr_accessor :name
    attr_accessor :user
    attr_accessor :password
    
    attr_reader :storage_path

    ##
    # Reference to server object
    attr_reader :server

    def initialize(server, &block)
      @server = server
      @storage_path = server.storage_databases_path
      instance_eval(&block) if block_given?
    end

    ##
    # Dumps database to SQL gzipped file using SSH
    def backup!
      ssh =  "ssh #{@server.user}@#{@server.host}"
      mysqldump = "mysqldump --user=#{@user} --password=#{@password} --opt"
      gzip = 'gzip -c'
      
      file_path = File.join(@storage_path, "#{@name}.sql.gz")
      command = "#{ssh} #{mysqldump} #{@name} | #{gzip} > #{file_path}"
      server.log "Dumping #{@name}"
      system(command)

    rescue Exception => err
      @exception = err

    ensure
      server.log(@exception) if @exception
    end

  end
end