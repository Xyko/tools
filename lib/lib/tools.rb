require 'singleton'
class ToolsUtil
  include Singleton

  def initialize(options = {})
    I18n.load_path = Dir[Tools.files + '/pt-BR.yml']
    I18n.locale    = 'pt-BR'.to_sym
    ToolsLog.instance
    ToolsLog.info "\tToolsLog Initialized."
    ToolsDisplay.instance
    ToolsLog.info "\tToolsDisplay Initialized."
    ToolsConfig.instance
    ToolsLog.info "\tToolsConfig Initialized."
    ToolsFiles.instance
    ToolsLog.info "\tToolsFiles Initialized."
  end

  def self.get_date format='%e %B %Y, %H:%M'
    return I18n.l(DateTime.now, :format => format)
  end

  def self.set_variable_ext variable, value
    if self.instance_variable_defined? ("@#{variable}")
      aux = self.get_variable variable
      case aux.class.to_s
      when 'String'
         self.set_variable variable, value
      when 'Hash'
         begin 
          aux.merge! value 
          self.set_variable variable, aux
        rescue
          ToolsDisplay.show "\ToolsDisplay error [set_variable_ext]. Attempt insert #{variable.class} into Hash variable....".light_red
        end
      when 'Array'
        aux.insert(-1,value)
        self.set_variable variable, aux
      end
    end
  end

  def self.set_variable variable, value
    self.instance_variable_set("@#{variable}", value)
  end

  def self.get_variable variable
    return self.instance_variable_get("@#{variable}")
  end


  def self.extract_argument argument, arguments
    status = false
    if arguments.include? argument
      status = true
      arguments.delete(argument)
    end
    return status, arguments
  end

  def self.extract_color arguments
    colors = String.colors
    color  = :default
    arguments.each do |argument|
      if colors.include? argument
        color = argument 
        arguments.delete(color)
      end
    end
    return color, arguments
  end

  def self.extract_option extract_options, arguments, single = false
    if single
      result = false
      extract_options.each do |extract|
        if arguments.include? extract
          index = arguments.index(extract)
          arguments.delete_at(index)
          result = true
        end
      end
    else
      result = nil
      extract_options.each do |extract|
        if arguments.include? extract
          index = arguments.index(extract)
          result = arguments[index+1]
          arguments.delete_at(index)
          arguments.delete_at(index)
        end
      end
    end
    return result, arguments
  end


##### sem minitest

  def self.purge_files path, select, time #Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60
    to_clean = Dir.glob(File.join(path, select)).select { |a| 
      Time.now - File.ctime(a) > time }
    to_clean.each do |file_to_delete|
      File.delete(file_to_delete)
    end
  end

end

module HashRecursiveBlank
  def rblank
    r = {}
    each_pair do |key, val|
      r[key] = val.rblank if val.is_a?(Hash)
    end
    return r.keep_if { |key, val| val.is_a?(Hash) }
  end

  def rblank!
    each_pair do |key, val|
      self[key] = val.rblank! if val.is_a?(Hash)
    end
    return keep_if { |key, val| val.is_a?(Hash) }
  end
end

module HashRecursiveMerge
  def rmerge(other_hash, concat_if_array = false)
    r = {}
    return merge(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        r[key] = oldval.rmerge(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        r[key] = concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end

  def rmerge!(other_hash, concat_if_array = false)
    return merge!(other_hash) do |key, oldval, newval|
      if oldval.is_a?(Hash)
        oldval.rmerge!(newval, concat_if_array)
      elsif oldval.is_a?(Array) and newval.is_a?(Array)
        concat_if_array ? oldval + newval : newval
      else
        newval
      end
    end
  end
end

class Hash
  include HashRecursiveMerge
  include HashRecursiveBlank

  def diff(other)
      (self.keys + other.keys).uniq.inject({}) do |memo, key|
        unless self[key] == other[key]
          if self[key].kind_of?(Hash) &&  other[key].kind_of?(Hash)
            memo[key] = self[key].diff(other[key])
          else
            memo[key] = [self[key], other[key]] 
          end
        end
        memo
      end
    end
end


class String

  def teste
    return "testando o teste"
  end

  def nil?
    return '' if self == nil
  end

  def fix(size, padstr=' ')
    self[0...size].rjust(size, padstr) #or ljust
  end

  def encrypt(key)
    Encrypt.dump self, key
  end

  def decrypt(key)
    Encrypt.load self, key
  end

  def alnum?
    !!match(/^[[:alnum:]]+$/)
  end

  def alpha?
    !!match(/^[[:alpha:]]+$/)
  end

end


class Object
  def boolean?
    self.is_a?(TrueClass) || self.is_a?(FalseClass) 
  end
end