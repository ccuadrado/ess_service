require "ess_api"
class RequestsController < ActionController::Base
  def status
    render :text => ESSServerAPI.capture_status
  end

  def record
    ESSServerAPI.start_capture
    render :text => "OK" 
  end
end
