require 'openstack-client'
require 'openstack-client/service_catalog'
require 'keystone/v2_0/tokens'
require 'keystone/v2_0/ec2'

module Keystone
  module V2_0
  end
end

class Keystone::V2_0::Client < ::Openstack::Client
  attr_accessor :username
  attr_accessor :tenant_id
  attr_accessor :tenant_name
  attr_accessor :password
  attr_accessor :auth_url
  attr_accessor :version
  attr_accessor :region_name

  attr_accessor :roles
  attr_accessor :services
  attr_accessor :tenants
  attr_accessor :tokens
  attr_accessor :users
  attr_accessor :service_catalog

  attr_accessor :user

  attr_accessor :ec2

  # Creates a new Keystone::V2_0::Client object.
  #
  # @param [Hash] options
  # @option options [String] :username Your Openstack username (optional)
  # @option options [String] :password Your Openstack password (optional)
  # @option options [String] :tenant_id Your Openstack tenantId (optional)
  # @option options [String] :tenant_name Your Openstack tenantName (optional)
  # @option options [String] :auth_url Keystone service endpoint for authorization.
  # @option options [String] :region_name The specific service region to use. Defaults to first returned region.
  # @option options [String] :token Whether to retry if your auth token expires (defaults to true)
  # @option options [String] :endpoint A user-supplied endpoint URL for the keystone
  #                                    service.  Lazy-authentication is possible for API
  #                                    service calls if endpoint is set at instantiation.(optional)
  #
  def initialize options={}
    self.username     = options[:username]
    self.tenant_id    = options[:tenant_id]
    self.tenant_name  = options[:tenant_name]
    self.password     = options[:password]
    self.auth_url     = options[:auth_url].chomp('/') if options[:auth_url]
    self.version      = 'v2.0'
    self.region_name  = options[:region_name]
    self.auth_token   = options[:token]

    # self.roles = roles.RoleManager(self)
    # self.services = services.ServiceManager(self)
    # self.tenants = tenants.TenantManager(self)
    self.tokens = Keystone::V2_0::TokenManager.new(self)
    # self.users = users.UserManager(self)

    # extensions
    self.ec2 = Keystone::V2_0::EC2CredentialsManager.new(self)

    unless options[:endpoint]
      authenticate
    else
      self.management_url = options[:endpoint]
    end
  end

  # Authenticate against the Keystone API.
  # 
  # Uses the data provided at instantiation to authenticate against
  # the Keystone server. This may use either a username and password
  # or token for authentication. If a tenant id was provided
  # then the resulting authenticated client will be scoped to that
  # tenant and contain a service catalog of available endpoints.
  # 
  # @return [boolean] if authentication was successful returns true.
  def authenticate
    self.management_url = self.auth_url
    raw_token = self.tokens.authenticate(
      username: username,
      tenant_id: tenant_id,
      tenant_name: tenant_name,
      password: password,
      token: auth_token,
      return_raw: true
    )
    self._extract_service_catalog(self.auth_url, raw_token)
    self.user = raw_token['user']
    return true
  end

  private
  def _extract_service_catalog url, body
    self.service_catalog  = Openstack::Client::ServiceCatalog.new(body)
    self.auth_token       = self.service_catalog.token['id']
    self.management_url   = self.service_catalog.url_for(
                                                    attribute: 'region',
                                                    filter_value: self.region_name,
                                                    endpoint_type: 'adminURL'
                                                  )
  end
end
