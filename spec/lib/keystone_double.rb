require 'keystone/v2_0/client'

module KeystoneDouble
  def service_catalog
    double('service_catalog').tap do |sc|
      sc.stub(:token) { { 'id' => 'token' } }
      sc.stub(:url_for) { 'http://url' }
    end
  end

  def keystone_client
    double('keystone').tap do |k|
      k.stub(:kind_of?) { true }
      k.stub(:service_catalog) { service_catalog }
    end
  end
end
