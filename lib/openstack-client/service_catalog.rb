require 'time'

module Openstack
  class Client
  end
end

# Helper class for dealing with a Keystone Service Catalog.
class Openstack::Client::ServiceCatalog
  attr_accessor :catalog

  def initialize resource_dict
    self.catalog = resource_dict
  end

  # Fetch token details fron service catalog
  # @return [Hash] token
  def token
    unless defined?(@token)
      @token = {
        'id' => self.catalog['token']['id'],
        'expires' => Time.parse(self.catalog['token']['expires'])
      }
      @token['tenant'] = self.catalog['token']['tenant']['id'] if self.catalog['token']['tenant']
    end
    @token
  end

  # Fetch an endpoint from the service catalog.
  # 
  # Fetch the specified endpoint from the service catalog for
  # a particular endpoint attribute. If no attribute is given, return
  # the first endpoint of the specified type.
  # 
  # See tests for a sample service catalog.
  # 
  # @param [Hash] options
  # @option options [String] :service_type    service type for url. (Default 'identity')
  # @option options [String] :endpoint_type   endpoint_type for url. (Default 'publicURL')
  # @option options [String] :attribute       attribute for filter.
  # @option options [String] :filter_value    filter_value for url.
  def url_for options={}
    service_type  = options[:service_type] || 'identity'
    endpoint_type = options[:endpoint_type] || 'publicURL'
    attribute     = options[:attribute]
    filter_value  = options[:filter_value]

    catalog = self.catalog['serviceCatalog'] || []

    catalog.each do |service|
      next unless service['type'] == service_type

      service['endpoints'].each do |endpoint|
        return endpoint[endpoint_type] if filter_value.nil? || endpoint[attribute] == filter_value
      end
    end

    raise 'Endpoint not found.'
  end

  # Fetch and filter endpoints for the specified service(s)
  # 
  # Returns endpoints for the specified service (or all) and
  # that contain the specified type (or all).
  def endpoints options={}
    service_type  = options[:service_type]
    endpoint_type = options[:endpoint_type]

    return {}.tap do |rtn|
      catalog = self.catalog['serviceCatalog'] || []

      catalog.each do |service|
        next if service_type and service_type != service['type']

        rtn[service['type']] = []
        service['endpoints'].each do |endpoint|
          next if endpoint_type and endpoint.include?(endpoint_type)
          rtn[service['type']] << endpoint
        end
      end
    end
  end

end
