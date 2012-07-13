require 'openssl'
require 'oauth-plugin'
require 'net/http'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'
require 'libxml'
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
    puts req.response.body
  end
  
  def self.load_credentials(type)
    creds = YAML.load_file(passwords_file)
    if type == :server   
      {"key" => creds["key"], "secret" => creds["secret"]}
    else 
      {"deviceauthentication" => creds["deviceauthentication"], "devicekey" => creds["devicekey"]}
    end

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
   
  def self.device_base_url
   "https://128.164.63.25:8443/"
  end
 
  def self.send_device_request(resource,params = {}, type = :get)
   oauth_creds = load_credentials :device
   auth = oauth_creds["deviceauthentication"]
   key = oauth_creds["devicekey"]
   hydra = Typhoeus::Hydra.new
   uri = device_base_url + resource
   
   if type == :get
     req = Typhoeus::Request.new(uri,:method => :get, :headers => {"Authorization" => "#{auth} #{key}"}, :disable_ssl_peer_verification => true, :disable_ssl_host_verification => true)
   else 
      req = Typhoeus::Request.new(uri,:method => :post, :headers => {"Authorization" => "#{auth} #{key}"}, :disable_ssl_peer_verification => true, :disable_ssl_host_verification => true, :params => params)
   end
   
   hydra.queue(req)
   hydra.run
   xml_to_json(req.response.body)

  end
  def self.start_capture(name = 'Test Capture', duration=240, capture_profile_name = "Upgraded Product Group 1")
    params = {:description => name, :duration => duration, :capture_profile_name => capture_profile_name}
    resource = "capture/new_capture"
    send_device_request(resource,params,:post)
  end
  

  def self.capture_status
    resource = "status/captures"
    send_device_request(resource)
  end

  def self.xml_to_json(xmlstring)
    parser = LibXML::XML::Parser.string(xmlstring)
    doc = parser.parse
    params = Hash.new
      params.merge!(find_in_xml(doc,"//status/current/state",:current_state,"idle"))
      params.merge!(find_in_xml(doc,"//status/current/start-time",:current_start,"No Capture Started"))
      params.merge!(find_in_xml(doc,"//status/current/duration",:current_duration,"0"))
      params.merge!(find_in_xml(doc,"//status/current/schedule/parameters/section",:current_section,"No Section Available"))
      params.merge!(find_in_xml(doc,"//status/current/schedule/parameters/presenters/presenter",:current_presenter,"No Presenter Found"))
      params.merge!(find_in_xml(doc,"//status/next/start-time",:next_start,"No Captures Scheduled"))
      params.merge!(find_in_xml(doc,"//status/next/duration",:next_duration,"0"))
      params.merge!(find_in_xml(doc,"//status/next/parameters/section",:next_section,"No Section Available"))
      params.merge!(find_in_xml(doc,"//status/current/schedule/parameters/presenters/presenter",:next_presenter,"No Presenter Assigned"))
    params.merge!(find_in_xml(doc,"//status/wall-clock-time",:wall_clock,"Device Unavailable"))
    params.to_json
  end

  def self.find_in_xml(doc,xmlpath,parameter,not_found_message)
    new_params = Hash.new
    target = doc.find(xmlpath)

    unless target.empty?
      new_params[parameter] = target.first.content
    else
      new_params[parameter] = not_found_message
    end
    new_params
  end
end
