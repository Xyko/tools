require 'singleton'
class ToolsDisplay
  include Singleton

  def self.show *arguments
    post                = arguments[0]
    color,arguments     = ToolsUtil.extract_color arguments
    sameline,arguments  = ToolsUtil.extract_argument :sameline, arguments
    nocolor,arguments   = ToolsUtil.extract_argument :nocolor, arguments
    colorized,arguments = ToolsUtil.extract_argument :colorized, arguments
    unless sameline
      post += "\n"
    end
    unless nocolor
      printf "#{post}".colorize(color)
    else
      if colorized
        ap post
      else
        printf "#{post}"
      end
    end
  end

end