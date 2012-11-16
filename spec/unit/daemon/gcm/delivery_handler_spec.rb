require "unit_spec_helper"

describe Rapns::Daemon::Gcm::DeliveryHandler do
  let(:delivery_handler) { Rapns::Daemon::Gcm::DeliveryHandler.new }
  let(:notification) { stub }
  let(:http) { stub(:shutdown => nil)}

  before do
    Net::HTTP::Persistent.stub(:new => http)
    Rapns::Daemon::Gcm::Delivery.stub(:perform)
  end

  it 'performs delivery of an notification' do
    Rapns::Daemon::Gcm::Delivery.should_receive(:perform).with(http, notification)
    delivery_handler.deliver(notification)
    delivery_handler.terminate
  end

  it 'initiates a persistent connection object' do
    Net::HTTP::Persistent.should_receive(:new).with('rapns')
    delivery_handler = Rapns::Daemon::Gcm::DeliveryHandler.new
    delivery_handler.terminate
  end

  it 'shuts down the http connection when finalized' do
    http.should_receive(:shutdown)
    delivery_handler.terminate
  end
end