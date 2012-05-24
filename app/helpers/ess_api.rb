require 'openssl'
require 'oauth-plugin'
require 'net/http'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'
module ESSServerAPI

  def initialize
    set_const(OpenSSL::SSL::VERIFY_PEER,OpenSSL::SSL::VERIFY_NONE)
  end

  def self.connect_server(resource)
    oauth_creds = YAML.load_file(passwords_file)
    consumer = OAuth::Consumer.new(oauth_creds["key"],oauth_creds["secret"],{:site => "https://128.164.60.181:8443/"})
    request_token = OAuth::RequestToken.new(consumer)
    access_token = OAuth::AccessToken.new(consumer)
    oauth_params = {:consumer => consumer, :token => access_token}
    hydra = Typhoeus::Hydra.new
    uri = base_url + resource
    req =Typhoeus::Request.new(uri,:disable_ssl_peer_verification => true, :disable_ssl_host_verification => true,:headers => {"Authorization" => "#{consumer.key} #{consumer.secret}"})
    oauth_helper = OAuth::Client::Helper.new(req,oauth_params.merge(:request_uri => uri))
    req.headers.merge!({"Authorization" => oauth_helper.header})
    hydra.queue(req)
    hydra.run
    req.response.body
  end

  def self.passwords_file
    File.expand_path(File.join(File.dirname(__FILE__),"passwords.yaml"))
  end
   
  def self.get_room_list
      response = connect_server("rooms/")
  end
  
  def self.base_url
    'https://128.164.60.181:8443/ess/scheduleapi/v1/'
  end

end
