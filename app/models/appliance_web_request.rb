require 'openssl'
require 'oauth-plugin'
require 'net/http'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

class ApplianceWebRequest
  attr_accessor :uri
  def initialize(uri)
    @uri = uri
  end
  
  def capture_status
    creds = load_credentials
    #Defining these here makes the request statement a bit cleaner.
    auth = creds["auth"]
    key = creds["key"]
    Typhoeus::Request.new(uri, :method => :get, :headers => {"Authorization" => "#{auth} #{key}"},:disable_ssl_peer_verification => true, :disable_ssl_host_verification => true) 
  end 

  def load_credentials
    creds = YAML.load_file(passwords_file)
    {"auth" => creds["deviceauthentication"], "key" => creds["devicekey"]}
  end

  def passwords_file
    File.expand_path(File.join(File.dirname(__FILE__),"../helpers/passwords.yaml"))
  end 
 
end
