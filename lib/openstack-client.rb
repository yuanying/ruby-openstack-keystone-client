require 'rest_client'
require 'json'

module Openstack

end

class Openstack::Client
  attr_accessor :auth_token

  attr_accessor :management_url
  
  def initialize keystone_or_options, options={}
    require 'keystone/v2_0/client'
    if keystone_or_options.kind_of?(Keystone::V2_0::Client)
      keystone = keystone_or_options
      endpoint_type = options[:endpoint_type] || 'publicURL'
      self.management_url = keystone.service_catalog.url_for(service_type: 'image', endpoint_type: endpoint_type)
      self.auth_token     = keystone.service_catalog.token['id']
    else
      options = keystone_or_options
      self.management_url = options[:endpoint]
      self.auth_token     = options[:token]
    end

    raise 'endpoint or Keystone::V2_0::Client object was required.' unless self.management_url
  end

  def get url, headers={}
    res = self.execute(method: :get, url: url, headers: headers)
  end

  def post url, payload, headers={}
    self.execute(method: :post, url: url, headers: headers, payload: payload)
  end

  def put url, payload, headers={}
    self.execute(method: :put, url: url, headers: headers, payload: payload)
  end

  def delete url, headers={}
    self.execute(method: :delete, url: url, headers: headers)
  end

  def execute options
    self.authenticate unless self.management_url

    options = options.dup

    options[:url] = self.management_url + options[:url]

    options[:headers] ||= {}
    options[:headers]['X-Auth-Token'] = self.auth_token if self.auth_token
    options[:headers]['User-Agent']   = 'ruby-openstack-client'
    options[:headers][:accept]        = :json

    if options[:payload]
      options[:headers][:content_type] = :json
      options[:payload] = options[:payload].to_json
    end

    response = RestClient::Request.execute(options)

    if [400, 401, 403, 404, 408, 409, 413, 500, 501].include?(response.code)
      raise "HTTP Error: #{response.code}"
    elsif [301, 302, 305].include?(response.code)
      options[:url] = response.headers[:location]
      return self.execute(options)
    end

    return [response, JSON.parse(response.to_s)]
  end

end

