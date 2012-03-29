require 'active_support/core_ext'

shared_examples 'Openstack::Client#initialize' do |manager_klasses|

  subject { described_class.new(initializing_param) }

  it "should be kind of #{described_class}" do
    should be_kind_of(described_class)
  end

  it 'should have management_url' do
    subject.management_url.should_not be_nil
  end

  it 'should have auth_token' do
    subject.auth_token.should_not be_nil
  end

  manager_klasses.each do |manager_klass|
    it "should have #{manager_klass}" do
      subject.send(manager_klass.to_s.split('::').last.gsub(/Manager$/, '').tableize.to_sym).should be_kind_of(manager_klass)
    end
  end

end
