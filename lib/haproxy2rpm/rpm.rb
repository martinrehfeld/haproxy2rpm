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

    def send(line)
      request = LineParser.new(line)
      NewRelic::Agent.record_transaction(
        request.tr / 1000.0,
        'metric' => "Controller#{request.uri}",
        'is_error' => request.is_error?,
        'error_message' => "Status code #{request.status_code}"
      )
      @qt_stat.record_data_point(request.tw / 1000.0)
    end
  end
end
