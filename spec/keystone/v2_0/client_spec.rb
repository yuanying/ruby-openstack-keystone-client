require 'spec_helper'
require 'keystone/v2_0/client'

describe Keystone::V2_0::Client do
  let(:valid_initialize_params) { {
      :username => 'valid',
      :password => 'valid_password',
      :tenant_name => 'it',
      :auth_url => 'http://auth.example.com:5000/v2.0/'
    }
  }
  before do
    stub_request(:post, 'http://auth.example.com:5000/v2.0/tokens').to_return(
      :status => 200,
      :body => "{\"access\": {\"token\": {\"expires\": \"2012-02-29T17:23:54\", \"id\": \"c8bb4eeb-4234-4c4a-b4b8-eddf7ed0862f\", \"tenant\": {\"id\": \"3\", \"name\": \"it\"}}, \"serviceCatalog\": [{\"endpoints\": [{\"adminURL\": \"http://10.21.55.30:8774/v1.1/3\", \"region\": \"RegionOne\", \"internalURL\": \"http://10.21.55.30:8774/v1.1/3\", \"publicURL\": \"http://10.21.55.30:8774/v1.1/3\"}], \"type\": \"compute\", \"name\": \"nova\"}, {\"endpoints\": [{\"adminURL\": \"http://10.21.55.30:9292/v1.1/3\", \"region\": \"RegionOne\", \"internalURL\": \"http://10.21.55.30:9292/v1.1/3\", \"publicURL\": \"http://10.21.55.30:9292/v1.1/3\"}], \"type\": \"image\", \"name\": \"glance\"}, {\"endpoints\": [{\"adminURL\": \"http://10.21.55.30:35357/v2.0\", \"region\": \"RegionOne\", \"internalURL\": \"http://10.21.55.30:5000/v2.0\", \"publicURL\": \"http://10.21.55.30:5000/v2.0\"}], \"type\": \"identity\", \"name\": \"keystone\"}, {\"endpoints\": [{\"adminURL\": \"https://10.21.55.30:8080/\", \"region\": \"RegionOne\", \"internalURL\": \"https://10.21.55.30:8080/v1/AUTH_3\", \"publicURL\": \"https://10.21.55.30:8080/v1/AUTH_3\"}], \"type\": \"object-store\", \"name\": \"swift\"}], \"user\": {\"id\": \"3\", \"roles\": [], \"name\": \"itadmin\"}}}",
      :headers => {:content_type=>"application/json; charset=UTF-8", :content_length=>"1098", :date=>"Wed, 29 Feb 2012 06:45:10 GMT"}
    )
  end
  let(:client) { Keystone::V2_0::Client.new(valid_initialize_params) }

  describe '#initialize' do
    context 'with valid auth_url and username and password and tenant_name' do

      it 'should return Openstack::Client' do
        client.should be_kind_of Openstack::Client
      end

      it 'should extract service catalog' do
        client.service_catalog.should_not be_nil
      end

      it 'should have user' do
        client.user.should == {"id"=>"3", "roles"=>[], "name"=>"itadmin"}
      end
    end

    context 'with valid auth_url and invalid username or password' do
      let(:params) { {
          :username => 'invalid',
          :password => 'XXXXXXX',
          :tenant_name => 'it',
          :auth_url => 'http://auth.example.com:5000/v2.0/'
        }
      }

      before do
        stub_request(:post, 'http://auth.example.com:5000/v2.0/tokens').to_return(
          :status => 401,
          :body => "{\"unauthorized\": {\"message\": \"Unauthorized\", \"code\": \"401\"}}",
          :headers => {:content_type=>"application/json; charset=UTF-8", :content_length=>"60", :date=>"Wed, 29 Feb 2012 07:03:14 GMT"}
        )
      end

      it 'should raise 401 HTTP Error.' do
        lambda {
          Keystone::V2_0::Client.new(params)
        }.should raise_error(RestClient::Unauthorized)
      end
    end

  end

  describe '#auth_url' do
    context 'when auth_url which has slash at end of url' do
      let(:auth_url) { valid_initialize_params[:auth_url] }
      it 'should not have slash at end of url' do
        client.auth_url.should == 'http://auth.example.com:5000/v2.0'
      end
    end
  end

end


