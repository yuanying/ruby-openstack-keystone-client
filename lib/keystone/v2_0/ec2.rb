require 'openstack-client/base'

module Keystone
  module V2_0
  end
end

class Keystone::V2_0::EC2 < Openstack::Client::Resource
end

class Keystone::V2_0::EC2CredentialsManager < Openstack::Client::Manager
  RESOURCE_CLASS = Keystone::V2_0::EC2

  def list user_id
    self._list("/users/#{user_id}/credentials/OS-EC2", "credentials")
  end
end
