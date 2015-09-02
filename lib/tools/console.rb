class Console

  def initialize(options = {})

  	commands

  end

  def commands

  	extend Prompt::DSL 

		group "Commands"

		desc "config"
		command "config" do ||
			Prompt.application.prompt = " tools > ".light_blue
		end

		desc "show"
		command "show" do ||
		end

		Prompt.application.prompt = " tools > ".light_red
		history_file = ".tools-history"  
		Prompt::Console.start history_file

  end

end
