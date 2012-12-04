require 'spec_helper'
require 'openstack-client/base'
require 'uri'

describe Openstack::Client::Resource do
  let(:manager) { double('manager') }
  let(:info)    { { 'test' => 'test' } }

  context 'when info was given' do
    let(:resource) { Openstack::Client::Resource.new(manager, info) }

    it 'should have "test" attribute' do
      resource.should be_respond_to(:test)
      resource.should be_respond_to(:'test=')
    end

  end
end

describe Openstack::Client::Manager do
  let(:api) { double{'api'} }
  let(:manager) { Openstack::Client::Manager.new(api) }

  describe '#resource_class' do
    it 'should have resource_class' do
      manager.resource_class.should == manager.class::RESOURCE_CLASS
    end
  end

  describe '#url_with_params' do
    context 'with blank params' do
      it 'should return simply url' do
        manager.url_with_params( '/test', { } ).
          should == '/test'
      end
    end

    context 'with params' do
      it 'should construct url with query from params' do
        url = manager.url_with_params( '/test', { 'name' => 'NAME', 'status' => 'stat us' } )
        params = (URI.parse url).query.split('&')
        params.include?('name=NAME').should be_true
        params.include?('status=stat%20us').should be_true
      end
    end

  end
end
