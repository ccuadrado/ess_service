class CaptureStatusMonitor
  attr_reader :status,:appliance

  def initialize(device_ip)
   @status = "No Contact"
   @appliance = CaptureAppliance.new(device_ip)
  end

  def base_url 
    "https://#{@ip_address}:8443/"
  end

  def capture_resource_path
    base_url + "status/captures"
  end

  def monitor_status
     @appliance.get_status
  end

end
