require 'libxml'

class ApplianceXMLParser
  def self.parse_xml_response(xmlstring)
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
