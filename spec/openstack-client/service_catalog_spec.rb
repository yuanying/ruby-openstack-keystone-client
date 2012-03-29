require 'spec_helper'
require 'openstack-client/service_catalog'

describe Openstack::Client::ServiceCatalog do

  let(:resource_dict) do
    {"token"=>{"expires"=>"2012-02-29T17:23:54", "id"=>"c8bb4eeb-4234-4c4a-b4b8-eddf7ed0862f", "tenant"=>{"id"=>"3", "name"=>"it"}}, "serviceCatalog"=>[{"endpoints"=>[{"adminURL"=>"http://10.21.55.30:8774/v1.1/3", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:8774/v1.1/3", "publicURL"=>"http://10.21.55.30:8774/v1.1/3"}], "type"=>"compute", "name"=>"nova"}, {"endpoints"=>[{"adminURL"=>"http://10.21.55.30:9292/v1.1/3", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:9292/v1.1/3", "publicURL"=>"http://10.21.55.30:9292/v1.1/3"}], "type"=>"image", "name"=>"glance"}, {"endpoints"=>[{"adminURL"=>"http://10.21.55.30:35357/v2.0", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:5000/v2.0", "publicURL"=>"http://10.21.55.30:5000/v2.0"}], "type"=>"identity", "name"=>"keystone"}, {"endpoints"=>[{"adminURL"=>"https://10.21.55.30:8080/", "region"=>"RegionOne", "internalURL"=>"https://10.21.55.30:8080/v1/AUTH_3", "publicURL"=>"https://10.21.55.30:8080/v1/AUTH_3"}], "type"=>"object-store", "name"=>"swift"}], "user"=>{"id"=>"3", "roles"=>[], "name"=>"itadmin"}}
  end
  let(:client) { Openstack::Client::ServiceCatalog.new(resource_dict) }

  describe '#catalog' do
    it 'should equal resource_dict' do
      client.catalog.should == resource_dict
    end
  end

  describe '#token' do
    
    it 'should contains resource_dict value' do
      client.token.should == {
        'id' => "c8bb4eeb-4234-4c4a-b4b8-eddf7ed0862f",
        'expires' => Time.parse("2012-02-29T17:23:54"),
        'tenant' => "3"
      }
    end
  end

  describe '#url_for' do

    context 'when no filtering,' do
      it 'should return identity service\'s publicURL' do
        client.url_for.should == "http://10.21.55.30:5000/v2.0"
      end
    end

    context 'when endpoint_type is adminURL' do
      it 'should return identity service\'s adminURL' do
        client.url_for(endpoint_type: 'adminURL').should == "http://10.21.55.30:35357/v2.0"
      end
    end

    context 'when service_type is compute' do
      it 'should return compute service\'s publicURL' do
        client.url_for(service_type: 'compute').should == "http://10.21.55.30:8774/v1.1/3"
      end
    end

  end

  describe '#endpoints' do

    context 'when no filtering' do
      it 'should return all endpoints' do
        client.endpoints.should == {
          'compute' => [{"adminURL"=>"http://10.21.55.30:8774/v1.1/3", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:8774/v1.1/3", "publicURL"=>"http://10.21.55.30:8774/v1.1/3"}],
          'image' => [{"adminURL"=>"http://10.21.55.30:9292/v1.1/3", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:9292/v1.1/3", "publicURL"=>"http://10.21.55.30:9292/v1.1/3"}],
          'identity' => [{"adminURL"=>"http://10.21.55.30:35357/v2.0", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:5000/v2.0", "publicURL"=>"http://10.21.55.30:5000/v2.0"}],
          'object-store' => [{"adminURL"=>"https://10.21.55.30:8080/", "region"=>"RegionOne", "internalURL"=>"https://10.21.55.30:8080/v1/AUTH_3", "publicURL"=>"https://10.21.55.30:8080/v1/AUTH_3"}]
        }
      end
    end

    context 'when service_type is compute' do
      it 'should return compute service\'s endpoints' do
        client.endpoints(service_type: 'compute').should == {
          'compute' => [{"adminURL"=>"http://10.21.55.30:8774/v1.1/3", "region"=>"RegionOne", "internalURL"=>"http://10.21.55.30:8774/v1.1/3", "publicURL"=>"http://10.21.55.30:8774/v1.1/3"}]
        }
      end
    end

  end

end
