require 'singleton'
class ToolsNet
  include Singleton

  def self.resolv_ip_name ip
    s = ''
    begin
      ret = Resolv.new.getname(ip)
      return ret.instance_variable_get('@labels').join('.')
    rescue Exception => e
      s = 'edi error: ' + e.message
    end
    return s.strip
  end

  def self.resolv_dns domain
    begin
      dns = Dnsruby::DNS.new({:nameserver => ['ns1.globoi.com', 'ns2.globoi.com'], })
      ret = dns.getaddress(domain).to_s
    rescue Exception => e
      case e.message
        when "Dnsruby::NXDomain"
          ret = nil
        else
          ret = e.message
      end
    end
    return ret
  end

end