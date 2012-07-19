require "ess_api"
class RequestsController < ActionController::Base
  def status
    @capture_monitor = CaptureStatusMonitor.new "128.164.63.25"
    render :text => @capture_monitor.monitor_status
  end

  def record
    @name = params[:name]
    ESSServerAPI.start_capture(@name)
    render :text => "OK"
  end
end
