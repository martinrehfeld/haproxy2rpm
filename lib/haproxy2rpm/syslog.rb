# Taken from
# https://raw.github.com/jordansissel/experiments/master/ruby/eventmachine-speed/basic.rb
module Haproxy2Rpm
  class SyslogHandler < EventMachine::Connection
    def initialize
      @rpm = Rpm.new
     end

    def receive_data(data)
      message_start_index = data.index('haproxy')
      message = data[message_start_index..-1]
      Haproxy2Rpm.logger.debug "RECEIVED (syslog): #{message}"
      @rpm.process_and_send(message)
    end
  end
end
