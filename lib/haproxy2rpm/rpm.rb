module Haproxy2Rpm
  class Rpm
    def initialize()
      NewRelic::Agent.manual_start
      @stats_engine = NewRelic::Agent.agent.stats_engine
    end
    
    def send(line)
      request = LineParser.new(line)
      NewRelic::Agent.record_transaction(
          request.tr / 1000.0,
          'metric' => "Controller#{request.uri}",
          'is_error' => request.is_error?)
      @stats_engine.get_stats_no_scope('WebFrontend/QueueTime').record_data_point(request.tw / 1000.0)
    end
  end
end
