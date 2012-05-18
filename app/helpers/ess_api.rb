require 'openssl'
require 'oauth'
require 'net/http'
module ESSServerAPI

  def initialize
    #This is done to get by a forged SSL cert until we can get a new one.
    const_set(OpenSSL::SSL::VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)
  end

  def self.connect_server
    oauth_creds = YAML.load_file(passwords_file)
    OAuth::Consumer.new(oauth_creds["key"],oauth_creds["secret"],{:site => "https://128.164.60.181:8443/"})
  end

  def self.passwords_file
    File.expand_path(File.join(File.dirname(__FILE__),"passwords.yaml"))
  end
end
