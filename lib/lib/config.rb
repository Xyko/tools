require 'singleton'
class ToolsConfig
  include Singleton

  def initialize(options = {})
    ToolsLog.info "\tInitializing ToolsConfig."
    unless File.exists? Tools.home+'/.tools'
      ToolsLog.info"\tCreating new directory in #{Tools.home+'/.tools'}."
      Dir.mkdir(Tools.home+'/.tools')
    end
    unless File.exists? Tools.home+'/.tools/backup'
      ToolsLog.info "\tCreating new directory in #{Tools.home+'/.tools/backup'}."
      FileUtils.mkdir_p(Tools.home+'/.tools/backup')
    end
    unless File.exists? Tools.home+'/.tools/config'
      ToolsConfig.create_config
    else
      ToolsConfig.validate_config
    end
    ToolsConfig.check_config
  end


  def self.create_config
    ToolsLog.info "\t\tCreating new config file in #{Tools.home+'/.tools/config'}."
    config_file = File.open(Tools.home+'/.tools/config', 'w')
    config = {}
    config['tools'] = {}
    config_file.write JSON.pretty_generate(config)
    config_file.close
  end

  def self.validate_config
    ToolsLog.info "\t\tValidanting config file in #{Tools.home+'/.tools/config'}."
    # ToolsConfig.daily_backup_config
    # ToolsConfig.purge_backup_config
    # file   = open(Cmdapi.home+'/.tools/config')
    # config = file.read
    # begin
    #   JSON.parse(config)
    #   return true
    # rescue Exception => e
    #   CMDAPIUtil.show_info "\tInvalid JSON config file in #{Cmdapi.home+'/.tools/config'}."
    #   CMDAPIUtil.show_info "\t Follow the instructions below to fix the problem."
    #   CMDAPIUtil.show_info "\t  1. Rename the config file #{Cmdapi.home+'/.tools/config'}."
    #   CMDAPIUtil.show_info "\t  2. Cmdapi run again. The cmdapi will create a new configuration file."
    #   CMDAPIUtil.show_info "\t  3. Copy the keys from the previous file to the new file."
    #   CMDAPIUtil.show_info "\t  4. Run cmdapi again.."
    #   CMDAPIUtil.show_info "\t Aborting operation...."
    #   exit
    # end
  end

  def self.check_config
    ToolsLog.info "\t\tChecking config file: #{Tools.home+'/.tools/config'}."
    # file = open(Tools.home+'/.tools/config')
    # json = file.read
    # parsed = JSON.parse(json)
    # file.close
  end

  def self.purge_backup_config   # execupa o purge de todos os backup com mais de 14 dias
    ToolsLog.info "\t\tPurge backup config file: #{Tools.home+'/.tools/config'}."
    #  to_clean = Dir.glob(File.join(Tools.home+'/.tools/backup', '*')).select { |a| 
    #   Time.now - File.ctime(a) > 14*24*60*60 }
    #  to_clean.each do |file_to_delete|
    #   File.delete(file_to_delete)
    # end
  end

  def self.config_backup
    ToolsLog.info "\t\tBackuping config file in #{Tools.home+'/.tools/backup'}."
  #   FileUtils.cp Tools.home+'/.tools/config', 
  #                Tolls.home+'/.tools/backup/config_' + 
  #                (ToolsUtil.get_date '%Y%m%d-%H%M') + '.backup'
  end

  def self.daily_backup_config
    #captura o backup mais recente
    least = Dir.glob(File.join(Cmdapi.home+'/.cmdapi3/backup', 'config*.backup')).max { |a,b| File.ctime(a) <=> File.ctime(b) }
    unless least.nil?
      #se não houver sido feito hoje
      unless File.ctime(least).to_date == Time.now.to_date
        ToolsLog.info "\t\tStarting config backup."
        ToolsConfig.config_backup
      end
    else
      ToolsLog.info "\t\tStarting config backup."
      ToolsConfig.config_backup
    end
    return true
  end

  def self.insert_in_config command
    source = Tools.home+'/.tools/config'
    file = open(source)
    json = file.read
    parsed = JSON.parse(json)
    unless parsed['tools'].nil?
      parsed['tools'].rmerge!(command)
    else
      parsed = command
    end
    file.close
    file = open(source, 'w')
    file.write JSON.pretty_generate(parsed)
    file.close
    return JSON.pretty_generate(parsed)
  end

end