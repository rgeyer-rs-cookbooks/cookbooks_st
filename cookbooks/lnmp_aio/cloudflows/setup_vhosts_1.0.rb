#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'trollop'
require 'rest_connection'

opts = Trollop::options do
  opt :account_id, "RightScale account ID", :required => true, :type => String
  opt :email, "RightScale Email Address", :required => true, :type => String
  opt :password, "RightScale Password", :required => true, :type => String
  opt :server_id, "RightScale Server ID", :required => true, :type => String
  opt :scripts_file, "JSON file with scripts to run", :required => true, :type => String
end

json = JSON.parse(File.read(opts[:scripts_file]))

server = Server.find(opts[:server_id].to_i)

json.each do |script|
  executable = Executable.new("recipe" => script["recipe_name"])
  server.run_executable(executable, script["parameters"])
end