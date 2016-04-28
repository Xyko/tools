require 'rubygems'
require 'awesome_print'
require 'colorize'
require 'prompt'
require 'thor'
require 'i18n'
require 'net/ssh'
require 'net/http'
require 'rsync'
require 'highline/import'
require 'tools/version'
require 'tools/toolsutil'
require 'tools/console'


module Tools

	class Configuration
	 attr_accessor :console_prompt, :host , :user, :home, :pwd, :ldap_user, :ldap_pass, :info
	end

	class << self
	  attr_accessor :configuration
	  def configure
	    self.configuration ||= Configuration.new
	    yield(configuration)
	  end
	end

	def self.root
    File.dirname __dir__
  end
  
  def self.bin
    File.join root, 'bin'
  end

  def self.lib
    File.join root, 'lib'
  end

  def self.files
    File.join root, 'lib/files'
  end

  def self.ssh_connect host, user, password
    begin
      @ssh = Net::SSH.start(host, user, :password => password, :timeout => 5)
      return @ssh
    rescue Timeout::Error
      puts '  Timed out'.red
    rescue Errno::EHOSTUNREACH
      puts '  Host unreachable'.red\
    rescue Errno::ECONNREFUSED
      puts '  Connection refused'.red
    rescue Net::SSH::AuthenticationFailed
      puts '  Authentication failure'.red
    rescue Exception => e
      puts ' Connection Error'.red
      puts ' '  + e.to_s.red
    end
    exit(0)
  end

  def self.ssh_connect_knowhost host, user
    begin
      @ssh = Net::SSH.start(host, user, :password => '', :timeout => 5)
      return @ssh
    rescue Timeout::Error
      puts '  Timed out'.red
    rescue Errno::EHOSTUNREACH
      puts '  Host unreachable'.red\
    rescue Errno::ECONNREFUSED
      puts '  Connection refused'.red
    rescue Net::SSH::AuthenticationFailed
      puts '  Authentication failure'.red
    rescue Exception => e
      puts ' Connection Error'.red
      puts ' '  + e.to_s.red
    end
    exit(0)
  end


  def self.ssh_cmd ssh, stringCommand
    result = ssh.exec!(stringCommand)
    return result.chomp
  end

  def self.set_variable variable, value
    self.instance_variable_set("@#{variable}", value)
  end

  def self.get_variable variable
   return self.instance_variable_get("@#{variable}")
  end


end

	Tools.configure do |config|

	 config.host          = ENV['HOST']
	 config.user          = ENV['USER']
	 config.home          = ENV['HOME']
	 config.pwd           = ENV['PWD']
	 config.ldap_user     = ENV['ldap_user']
	 config.ldap_pass     = ENV['ldap_pass']
	 if File.exists? Tools.configuration.home+'/xyko/tools.rb'
	 	require Tools.configuration.home+'/xyko/tools.rb' 
	 	config.info = get_tools_info
	 end

	end


	module HashRecursiveMerge
	  def rmerge(other_hash)
	    r = {}
	    merge(other_hash) do |key, oldval, newval|
	      r[key] = oldval.is_a?(Hash) ? oldval.rmerge(newval) : newval
	    end
	  end
	  def rmerge!(other_hash)
	    merge!(other_hash) do |key, oldval, newval|
	      oldval.is_a?(Hash) ? oldval.rmerge!(newval) : newval
	    end
	  end
	end


	module HashRecursiveBlank
	  def rblank
	    r = {}
	    each_pair do |key, val|
	      r[key] = val.rblank if val.is_a?(Hash)
	    end
	    r.keep_if { |key, val| val.is_a?(Hash) }
	  end

	  def rblank!
	    each_pair do |key, val|
	      self[key] = val.rblank! if val.is_a?(Hash)
	    end
	    keep_if { |key, val| val.is_a?(Hash) }
	  end
	end

	class Hash
	  include HashRecursiveBlank
	  include HashRecursiveMerge
	end

	class String
	  def to_bool
	    return true if self.eql?('true')
	    return false if self.eql?('false')
	    return nil
	  end

	  def nil?
	    return '' if self == nil
	  end
	end



