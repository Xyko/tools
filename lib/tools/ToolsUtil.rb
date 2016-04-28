class ToolsUtil 

  def initialize(options = {})

  	I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
    I18n.locale = 'pt-BR'.to_sym

  end

  def root
  	return Tools.root
  end

  def bin
  	return Tools.bin
  end


 def show_info msg 
    show  msg, :light_blue 
  end

  def show_warning msg
    show msg, :yellow
  end

  def show_error msg
    show msg, :light_red
  end
  
  def show msg, color=:gray
          
      case msg.class.to_s
        when 'String' 
          puts msg.colorize(color)
        when 'Hash' 
            ap msg, :multiline  => true, :index => false, :indent => 2
        when 'Array'
          msg.each do |line|
            ap line
          end
        else
          puts msg.to_s.gray
      end

  end


  def get_id
    sleep 1
    return Time.now.to_i
  end


end