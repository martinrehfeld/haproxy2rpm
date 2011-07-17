$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require "newrelic_rpm"
require "eventmachine"
require "eventmachine-tail"
require "haproxy2rpm/version"
require "haproxy2rpm/file_parser"
require "haproxy2rpm/line_parser"
require "haproxy2rpm/syslog"
require "haproxy2rpm/rpm"

module Haproxy2Rpm

  class << self 
    attr_accessor :logger, :rpm
    
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

  def self.run(log_file, options)
    @rpm = Rpm.new(options)
    if(options[:daemonize])
      logger.info 'daemonizing'
      run_daemonized(log_file, options)
    else
      write_pid(options[:pid], Process.pid)
      if(options[:syslog])
        run_syslog_server(options)
      else
        default_run(log_file, options)
      end
    end
  end

  def self.stop
    logger.info 'stopping new relic agent'
    NewRelic::Agent.shutdown
  end

  def self.run_syslog_server(options)
    EventMachine::run do
      EventMachine::open_datagram_socket(options[:address], options[:port], SyslogHandler)
    end
  end

  def self.default_run(log_file,options)
    EventMachine.run do
      EventMachine::file_tail(log_file) do |filetail, line|
        @rpm.process_and_send(line)
      end
    end
  end
    
  def self.run_daemonized(log_file, options)
      Signal.trap('HUP') {}
      
      pid = fork do
        begin
          if(options[:syslog])
            run_syslog_server(options)
          else
            default_run(log_file, options)
          end
        rescue => e
          logger.error e.message
          logger.error e.backtrace.join("\n")
          abort "There was a fatal system error while starting haproxy2rpm"
        end
      end
      
      write_pid(options[:pid], pid)
      
      ::Process.detach pid
      
      exit
  end

  def self.write_pid(pid_file, pid)
    if pid_file
      File.open(pid_file, 'w') { |f| f.write pid }
    end 
  end
end
