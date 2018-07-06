require 'singleton'
class ToolsLog
  include Singleton

  def initialize(options = {})
    tools_logfile     = Tools.home+'/.tools/tools.log'
    if File.exists? tools_logfile
      unless File.ctime(tools_logfile).to_date == Time.now.to_date
        File.delete(tools_logfile)
      end
    end
    ToolsUtil.set_variable 'tools_logfile', tools_logfile
    ToolsUtil.set_variable 'logger', Logger.new(tools_logfile, 'daily')
    (ToolsUtil.get_variable 'logger').formatter = proc do |severity, datetime, progname, msg|
      "#{severity.chars.first} #{datetime.strftime "%H:%M:%S"}: #{msg}\n"
    end
    ToolsUtil.purge_files Tools.home+'/.tools/backup', '*', 14*24*60*60
  end

  def self.method_missing(method, *args, &block)
    logger      = ToolsUtil.get_variable 'logger'
    color,args  = ToolsUtil.extract_color args 
    if color.eql? :default
      case method.to_s
        when 'info'
          color = :cyan
        when 'warn'
          color = :yellow
        when 'debug'
          color = :green
        when 'error'
          color = :light_red
      end
    end
    logger.method(method).call args.first.colorize(color) 
  end

end