module Haproxy2Rpm
  class Rpm
    def initialize()
      NewRelic::Agent.manual_start
      @stats_engine = NewRelic::Agent.agent.stats_engine
    end
    
    def send(line)
      request = LineParser.new(line)
      @stats_engine.get_stats('Custom/HAProxy/response_times',false).record_data_point(request.tr)
    end
  end
end