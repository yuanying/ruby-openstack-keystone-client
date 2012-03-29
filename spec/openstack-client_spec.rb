require 'spec_helper'
require 'openstack-client'

describe Openstack::Client do

  describe '#execute' do
    let(:endpoint) { 'http://www.example.com/v2.0' }
    let(:url)      { '/url' }
    let(:auth_token) { nil }
    let(:init_params) {{
      endpoint: endpoint,
      token:    auth_token
    }}
    let(:exec_params) {{
      url: url
    }}
    let(:rest_client_params) {{
      url: endpoint + url,
      headers: {
        'User-Agent' => 'ruby-openstack-client',
        accept: :json
      }
    }}
    let(:response) { double('response').tap { |res| res.stub(:code){200}; res.stub(:to_s) { '{"a":1}' } } }
    let(:client) { Openstack::Client.new(init_params)}

    context 'when execute url: "/url"' do
      it 'should call RestClient::Request.execute with rest_client_params' do
        RestClient::Request.should_receive(:execute).with(rest_client_params).and_return(response)
        client.execute(exec_params)
      end
    end

    context 'when token was given at initializing' do
      let(:auth_token) { 'AUTH_TOKEN______' }

      it 'should call RestClient::Request.execute with X-Auth-Token header' do
        rest_client_params[:headers]['X-Auth-Token'] = auth_token
        RestClient::Request.should_receive(:execute).with(rest_client_params).and_return(response)
        client.execute(exec_params)
      end
    end

    context 'when payload was given at executing' do
      let(:payload) { '{}' }

      it 'should call RestClient::Request.execute with content-type: json header' do
        rest_client_params[:headers][:content_type] = :json
        rest_client_params[:payload] = payload.to_json
        exec_params[:payload] = payload
        RestClient::Request.should_receive(:execute).with(rest_client_params).and_return(response)
        client.execute(exec_params)
      end
    end

  end

end
