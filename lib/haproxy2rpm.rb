$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require "newrelic_rpm"
require "eventmachine"
require "haproxy2rpm/version"
require "haproxy2rpm/file_parser"
require "haproxy2rpm/line_parser"
require "haproxy2rpm/reader"

module Haproxy2Rpm
  def self.run(log_file)
    NewRelic::Agent.manual_start :app_name => 'MLI RPM TEST'
    stats_engine = NewRelic::Agent.agent.stats_engine
    EventMachine.run do
      EventMachine::file_tail(log_file) do |filetail, line|
        request = LineParser.new(line)
        stats_engine.get_stats('Controllers/main/login',false).record_data_point(request.tr)
        stats_engine.get_stats('Controllers/response_times',false).record_data_point(request.tr)
      end
    end
  end

  def self.stop
    puts 'stopping new relic agent'
    NewRelic::Agent.shutdown
  end
end
