require 'typhoeus'
require 'libxml'
class CaptureAppliance
  attr_reader :ip_address 
  attr_accessor :client
  
  def initialize(device_ip)
    @ip_address = device_ip
    @client = Typhoeus::Hydra.new
  end

  def get_status
    web_request = ApplianceWebRequest.new(status_uri)
    status_request = web_request.capture_status
    @client.queue(status_request)
    @client.run
    ApplianceXMLParser.parse_xml_response(status_request.response.body)
  end 

  def base_uri 
    "https://#{@ip_address}:8443/"
  end 

  def status_uri
    "#{base_uri}status/captures"
  end

end
