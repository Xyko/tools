class ToolsUtil 

  def initialize(options = {})

  	I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
    I18n.locale = 'pt-BR'.to_sym

  end

end