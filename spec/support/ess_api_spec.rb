require 'spec_helper'
require 'ess_api'

describe "ESS API" do
  it "tests the truth" do
    true
  end

 it "reads from the passwords file" do
   creds = ESSServerAPI.load_credentials(:server)
   creds.should_not be_nil
 end

 it "should have two different passwords for device and server" do
   devicePass = ESSServerAPI.load_credentials(:device)
   serverPass = ESSServerAPI.load_credentials(:server)
   devicePass.should_not be_nil
   serverPass.should_not be_nil
   devicePass.should_not equal serverPass
 end 
end
