require "ess_api"
class RequestsController < ActionController::Base
  def status
    render :text => ESSServerAPI.capture_status
  end

  def record
    @name = params[:name]
    ESSServerAPI.start_capture(@name)
    render :text => "OK" 
  end
end
