Ruby Openstack Keystone Client
=============================================================

## Description

This is a client for the OpenStack Keystone/Glance/Nova API. There's a Ruby API.

## Keystone API

The Keystone 2.0 API is still a moving target, so this module will remain in
"Beta" status until the API is finalized and fully implemented.

### Examples

See the class definitions for documentation on specific methods and operations.

    require 'keystone/v2_0/client'
    require 'pp'

    begin
      client = Keystone::V2_0::Client.new(
        :username => 'username',
        :password => 'password',
        :tenant_name => 'demo',
        :auth_url => 'http://example.com:5000/v2.0/'
      )

      pp client.user
      # =>
      # {"id"=>"9",
      #  "roles"=>
      #   [{"tenantId"=>"2", "id"=>"1", "name"=>"Admin"},
      #    {"tenantId"=>"2", "id"=>"2", "name"=>"Member"}],
      #  "name"=>"forecast_user"}

      pp client.service_catalog.token
      # =>
      # {"id"=>"2a0996fe-e070-4a73-b6b5-6e940070f207",
      #  "expires"=>2012-03-01 13:57:42 +0900,
      #  "tenant"=>"2"}

      pp client.service_catalog.endpoints
      # =>
      # {"compute"=>
      #   [{"adminURL"=>"http://example.com:8774/v1.1/2",
      #     "region"=>"RegionOne",
      #     "internalURL"=>"http://example.com:8774/v1.1/2",
      #     "publicURL"=>"http://example.com:8774/v1.1/2"}],
      #  "image"=>
      #   [{"adminURL"=>"http://example.com:9292/v1.1/2",
      #     "region"=>"RegionOne",
      #     "internalURL"=>"http://example.com:9292/v1.1/2",
      #     "publicURL"=>"http://example.com:9292/v1.1/2"}],
      #  "identity"=>
      #   [{"adminURL"=>"http://example.com:35357/v2.0",
      #     "region"=>"RegionOne",
      #     "internalURL"=>"http://example.com:5000/v2.0",
      #     "publicURL"=>"http://example.com:5000/v2.0"}],
      #  "object-store"=>
      #   [{"adminURL"=>"http://example.com:8080/",
      #     "region"=>"RegionOne",
      #     "internalURL"=>"http://example.com:8080/v1/AUTH_2",
      #     "publicURL"=>"http://example.com:8080/v1/AUTH_2"}],
      #  "ec2"=>
      #   [{"adminURL"=>"http://example.com:8773/services/Admin",
      #     "region"=>"RegionOne",
      #     "internalURL"=>"http://example.com:8773/services/Cloud",
      #     "publicURL"=>"http://example.com:8773/services/Cloud"}]}
    rescue
      puts 'Authentication Failed.'
    end


## Authors

-   Yuanying <yuanying@fraction.jp>
-   atoato88 <atoato88@gmail.com>


## License

See LICENSE for license information.
