require 'spec_helper'
require 'ess_api'

describe "ESS API" do
  it "tests the truth" do
    true
  end

 it "should return valid OAuth token" do
   @consumer = ESSServerAPI.connect_server("rooms/")
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
 
 it "should return a room list with length greater than zero" do
   rooms = ESSServerAPI.get_room_list
   rooms.size.should be > 0
 end 
end
