module Haproxy2Rpm
  class Rpm
    
    def initialize(options = {})
      agent_options = {:log => Haproxy2Rpm.logger}
      agent_options[:app_name] = options[:app_name] if options[:app_name]
      agent_options[:env] = options[:env] if options[:env]
     NewRelic::Agent.manual_start agent_options
      @stats_engine = NewRelic::Agent.agent.stats_engine
      @qt_stat = @stats_engine.get_stats_no_scope('WebFrontend/QueueTime')
    end
    
    def qt_stat=(stat)
      @qt_stat = stat
    end

    def process_and_send(line)
      request_recorder.call(message_parser.call(line))
    end
    
    def default_message_parser
      lambda do |line|
        LineParser.new(line)
      end
    end
    
    def message_parser
      @message_parser ||= default_message_parser
    end
    
    def message_parser=(block)
      @message_parser = block
    end
    
    def default_message_recorder
      lambda do |request|
        rpm_number_unit = 1000.0
        params = {
          'metric' => "Controller#{request.http_path}"
        }

        if request.is_error?
          params['is_error'] = true
          params['error_message'] = "#{request.uri} : Status code #{request.status_code}"
        end

        NewRelic::Agent.record_transaction(request.tr / rpm_number_unit, params)
        Haproxy2Rpm.logger.debug "RECORDING (transaction): #{params.inspect}"
        result = @qt_stat.record_data_point(request.tw / rpm_number_unit)
        Haproxy2Rpm.logger.debug "RECORDING (data point): wait time #{request.tw}, #{result.inspect}"
      end
    end
    
    def request_recorder
      @request_recorder ||= default_message_recorder
    end
    
    def request_recorder=(block)
      @request_recorder = block
    end
  end
end
