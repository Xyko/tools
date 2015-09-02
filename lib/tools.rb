require 'rubygems'
require 'awesome_print'
require 'colorize'
require 'prompt'
require 'thor'
require 'i18n'
require 'tools/version'
require 'tools/toolsutil'
require 'tools/console'


module Tools

	class Configuration
	 attr_accessor :console_prompt
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


end
