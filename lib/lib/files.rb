require 'singleton'
class ToolsFiles
  include Singleton

  def initialize(options = {})
  end


  # Create a directory in work area
  #
  #  Sample
  # ToolsFiles.create_dir Tools.home + '/2018/xykotools/tools/home', 'tools_home'
  # home = (ToolsUtil.get_variable 'tools_home') => ~/2018/xykotools/tools/home
  #
  # @param directory
  # @param directory_name
  # @return
  def self.create_dir directory, directory_name
    unless directory.end_with? '/'
      directory += '/'
    end
    complete_file = (directory + '/').gsub('//','/')
    unless File.exists? complete_file
      Dir.mkdir(complete_file)
    end
    ToolsUtil.set_variable directory_name, complete_file
  end

  # Create a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.create_file home, 'xyko_file.txt', 'xyko_file'
  #  xyko = (ToolsUtil.get_variable 'xyko_file') => ~/2018/xykotools/tools/home/xyko_file.txt
  #
  # @param directory
  # @param file_name
  # @param file_name_set
  # @return
  def self.create_file directory, file_name, file_name_set
    complete_file = (directory + '/' + file_name).gsub('//','/')
    unless File.exists? complete_file
      file = File.open( complete_file , 'w')
    end
    ToolsUtil.set_variable file_name_set, complete_file
  end




end