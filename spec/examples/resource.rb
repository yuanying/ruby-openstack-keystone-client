
shared_examples 'Openstack::Client::Resource#initialize' do |attributes|

  attributes.each do |k, v|
    it "should have #{k} attribute" do
      should be_respond_to(k.to_sym)
      should be_respond_to("#{k}=".to_sym)
    end
  end
end
