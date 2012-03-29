require 'openstack-client/base'

module Keystone
  module V2_0

    class Token < Openstack::Client::Resource
      def initialize manager, info, loaded=nil
        super
      end
    end

    class TokenManager < Openstack::Client::Manager
      RESOURCE_CLASS = Token

      def initialize api
        super
      end

      # options:
      #   :username
      #   :tenant_id
      #   :tenant_name
      #   :password
      #   :token
      #   :return_raw
      def authenticate options
        if options[:token]
          params = { 'auth' => { 'token' => { 'id' => options[:token] } } }
        elsif options[:username] and options[:password]
          params = { 
            'auth' => { 
              'passwordCredentials' => {
                'username' => options[:username],
                'password' => options[:password]
          }}}
        else
          raise 'A username and password or token is required.'
        end

        if options[:tenant_id]
          params['auth']['tenantId'] = options[:tenant_id]
        elsif options[:tenant_name]
          params['auth']['tenantName'] = options[:tenant_name]
        end

        return self._create('/tokens', params, 'access', options[:return_raw])
      end

      def delete token
        self._delete("/tokens/#{token.id}")
      end

      def endpoints token
        self._get("/tokens/#{token.id}/endpoints", 'token')
      end

    end

  end
end
