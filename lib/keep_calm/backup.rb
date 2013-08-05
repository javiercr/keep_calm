# encoding: utf-8
require 'fileutils'

module KeepCalm
  class Backup

    # Array of configured Servers objects.
    attr_reader :servers

    ##
    # Array of configured Notifier objects.
    attr_reader :notifiers

    ##
    # Path for store backups
    attr_reader :storage_path

    ##
    # Path for folders backups
    attr_reader :storage_folders_path

    ##
    # Path for databases backups
    attr_reader :storage_databases_path

    ##
    # The time when the backup initiated (as a Time object)
    attr_reader :started_at

    ##
    # The time when the backup finished (as a Time object)
    attr_reader :finished_at

    ##
    # Exception raised by either a +before+ hook or one of the model's
    # procedures that caused the model to fail. An exception raised by an
    # +after+ hook would not be stored here. Therefore, it is possible for
    # this to be +nil+ even if #exit_status is 2 or 3.
    attr_reader :exception

    def initialize(storage_path)
      @servers  = []
      @notifiers  = []
      @storage_path = storage_path
      create_paths
    end

    ##
    # Adds a Server to backup
    def server(&block)
      @servers << Server.new(self, &block)
    end


    ##
    # Adds an Notifier. Multiple Notifiers may be added to the model.
    def notify_by(name, &block)
      @notifiers << get_class_from_scope(Notifier, name).new(self, &block)
    end


    ##
    # Performs the backup process
    #
    # Once complete, #exit_status will indicate the result of this process.
    #
    # If any errors occur during the backup process, all temporary files will
    # be left in place. If the error occurs before Packaging, then the
    # temporary folder (tmp_path/trigger) will remain and may contain all or
    # some of the configured Archives and/or Database dumps. If the error
    # occurs after Packaging, but before the Storages complete, then the final
    # packaged files (located in the root of tmp_path) will remain.
    #
    # *** Important ***
    # If an error occurs and any of the above mentioned temporary files remain,
    # those files *** will be removed *** before the next scheduled backup for
    # the same trigger.
    def perform!
      @started_at = Time.now.utc

      # log!(:started)

      @servers.each do |server|
        server.backup!
      end

    rescue Exception => err
      @exception = err
      p @exception

    ensure
      @finished_at = Time.now.utc
      # log!(:finished)
    end


    def log(msg)
      p msg
    end

    private

    ##

    ##
    # Logs messages when the model starts and finishes.
    #
    # #exception will be set here if #exit_status is > 1,
    # since log(:finished) is called before the +after+ hook.
    def log!(action)
      case action
      when :started
        Logger.info "Performing Backup for '#{ label } (#{ trigger })'!\n" +
            "[ backup #{ VERSION } : #{ RUBY_DESCRIPTION } ]"

      when :finished
        if exit_status > 1
          ex = exit_status == 2 ? Error : FatalError
          err = ex.wrap(exception, "Backup for #{ label } (#{ trigger }) Failed!")
          Logger.error err
          Logger.error "\nBacktrace:\n\s\s" + err.backtrace.join("\n\s\s") + "\n\n"

          Cleaner.warnings(self)
        else
          msg = "Backup for '#{ label } (#{ trigger })' "
          if exit_status == 1
            msg << "Completed Successfully (with Warnings) in #{ duration }"
            Logger.warn msg
          else
            msg << "Completed Successfully in #{ duration }"
            Logger.info msg
          end
        end
      end
    end

    ## 
    # Creates directories for the backup
    def create_paths
      @storage_folders_path = File.join(@storage_path, "folders") # Not need date because we use rsync
      FileUtils.mkdir_p @storage_folders_path

      today = Time.now
      @storage_databases_path = File.join(@storage_path, "databases", today.year.to_s, today.month.to_s, today.day.to_s)
      FileUtils.mkdir_p @storage_databases_path
    end


  end
end
