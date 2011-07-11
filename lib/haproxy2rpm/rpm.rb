module Haproxy2Rpm
  class Rpm
    def initialize(options = {})
      agent_options = {}
      agent_options[:app_name] = options[:app_name] if options[:app_name]
      agent_options[:env] = options[:env] if options[:env]
      NewRelic::Agent.manual_start agent_options
      @stats_engine = NewRelic::Agent.agent.stats_engine
      @qt_stat = @stats_engine.get_stats_no_scope('WebFrontend/QueueTime')
    end

    def process_and_send(line)
      request = LineParser.new(line)
      params = {
        'metric' => "Controller#{request.http_path}"
      }

      if request.is_error?
        params['is_error'] = true
        params['error_message'] = "#{request.uri} : Status code #{request.status_code}"
      end

      NewRelic::Agent.record_transaction(request.tr / 1000.0, params)
      @qt_stat.record_data_point(request.tw / 1000.0)
    end
  end
end
