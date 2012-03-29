require 'openstack-client'
require 'uri'

class Openstack::Client::Resource
  attr_accessor :manager
  attr_accessor :info
  attr_accessor :loaded

  def self.delegate methods, options
    to = options[:to]
    methods.each do |method|
      module_eval <<-EOM
        def #{method.to_s} *args, &block
          args.unshift(self)
          self.#{to.to_s}.send(:#{method.to_s}, *args, &block)
        end
      EOM
    end
  end

  def initialize manager, info, loaded=nil
    self.manager  = manager
    self.info     = info
    self.loaded   = loaded

    self.add_details(info)
  end

  def add_details info
    info.each do |name, v|
      unless self.respond_to?(name.to_sym)
        self.instance_eval <<-EOM
          def #{name}
            self.info['#{name}']
          end
          def #{name}= val
            self.info['#{name}'] = val
          end
        EOM
      end
    end
  end

  def method_missing(name, *args)
    self.get unless self.loaded

    return self.send(name, *args) if self.respond_to?(name)
    super
  end

  def get
    self.loaded = true

    res = self.manager.get(self.id)
    self.info = res.info
    self.add_details(self.info)
    return self
  end
end

class Openstack::Client::Manager
  RESOURCE_CLASS = Openstack::Client::Resource
  attr_accessor :resource_class
  attr_accessor :api

  def initialize api
    self.api = api
    self.resource_class = self.class::RESOURCE_CLASS
  end

  def get_id obj
    if obj.kind_of? String
      return obj
    elsif obj.respond_to?(:id)
      return obj.id
    elsif obj.respond_to?(:uuid)
      return obj.uuid
    end
    raise "No ID of this object: #{obj}"
  end

  def url_with_params url, options={}
    unless options.nil? || options.empty?
      url += ('?' + options.to_a.map{|a| "#{a.first}=#{a.last}"}.join('&'))
    end
    URI.escape(url)
  end

  def _list url, response_key, body=nil
    if body
      resp, body = self.api.post(url, body)
    else
      resp, body = self.api.get(url)
    end

    data = body[response_key]
    data = data['values'] if data.kind_of? Hash

    return [].tap do |rtn|
      data.each do |d|
        rtn << self.resource_class.new(self, d, true)
      end
    end
  end

  def _get url, response_key
    resp, body = self.api.get(url)
    return self.resource_class.new(self, body[response_key])
  end

  def _create url, body, response_key, return_raw=false
    resp, body = self.api.post(url, body)
    if return_raw
      return body[response_key]
    else
      return self.resource_class.new(self, body[response_key])
    end
  end

  def _delete url
    self.api.delete(url)
  end

  def _update url, body, response_key=nil, method=:put
    resp, body = self.api.send(method, url, body)
    return self.resource_class.new(self, body[response_key]) if body
    return resp
  end

end