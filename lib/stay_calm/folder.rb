module KeepCalm
  class Folder

    attr_accessor :key
    attr_accessor :path
    
    attr_reader :storage_path

    ##
    # Reference to server object
    attr_reader :server

    def initialize(server, &block)
      @server = server
      @storage_path = server.storage_folders_path
      instance_eval(&block) if block_given?
    end

    ##
    # Backups the specified folder using rsync
    def backup!
      ssh =  "#{@server.user}@#{@server.host}"
      src = "#{ssh}:#{@path}"
      dest = File.join(@storage_path, @key)
      FileUtils.mkdir_p dest
      command = "rsync #{src} #{dest} -a"
      server.log "Rsync #{@path}"
      system(command)

    rescue Exception => err
      @exception = err

    ensure
      server.log(@exception) if @exception
    end
  end
end