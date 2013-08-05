require "keep_calm/version"

module KeepCalm
  ##
  # KeepCalms's internal paths
  LIBRARY_PATH = File.join(File.dirname(__FILE__), 'keep_calm')
  
  ##
  # Require KeepCalm base files
  %w{
    backup
    database
    folder
    server
  }.each {|lib| require File.join(LIBRARY_PATH, lib) }
end
