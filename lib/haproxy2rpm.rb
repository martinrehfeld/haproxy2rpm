$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require "newrelic_rpm"
require "eventmachine"
require "eventmachine-tail"
require "haproxy2rpm/version"
require "haproxy2rpm/file_parser"
require "haproxy2rpm/line_parser"

module Haproxy2Rpm
  def self.run(log_file, options)
    if(options[:daemonize])
      puts 'daemonizing'
      run_daemonized(log_file, options)
    else
      default_run(log_file, options)
    end
  end

  def self.stop
    puts 'stopping new relic agent'
    NewRelic::Agent.shutdown
  end
  
  def self.default_run(log_file,options)
    NewRelic::Agent.manual_start
    stats_engine = NewRelic::Agent.agent.stats_engine
    EventMachine.run do
      EventMachine::file_tail(log_file) do |filetail, line|
        request = LineParser.new(line)
        stats_engine.get_stats('Custom/HAProxy/response_times',false).record_data_point(request.tr)
      end
    end
  end
  
  def self.run_daemonized(log_file, options)
      Signal.trap('HUP') {}
      
      pid = fork do
        begin
          default_run(log_file, options)
        rescue => e
          puts e.message
          puts e.backtrace.join("\n")
          abort "There was a fatal system error while starting haproxy2rpm"
        end
      end
      
      if options[:pid]
        File.open(options[:pid], 'w') { |f| f.write pid }
      end
      
      ::Process.detach pid
      
      exit
  end
end