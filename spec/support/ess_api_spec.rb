require 'spec_helper'
require 'ess_api'

describe "ESS API" do
  it "tests the truth" do
    true
  end

 it "should return valid OAuth token" do
   @consumer = ESSServerAPI.connect_server
   @consumer.should_not be_nil 
  end

 it "should have valid OAuth Key and Secret" do
    passwords = YAML.load_file(ESSServerAPI.passwords_file)
    passwords.should_not be_nil
 end

 it "should get a room list" do
   rooms = ESSServerAPI.get_room_list
   rooms.should_not be_nil
 end 
end
