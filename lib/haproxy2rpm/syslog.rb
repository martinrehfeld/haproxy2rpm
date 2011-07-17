# Taken from
# https://raw.github.com/jordansissel/experiments/master/ruby/eventmachine-speed/basic.rb
module Haproxy2Rpm
  class SyslogHandler < EventMachine::Connection
    def receive_data(data)
      message_start_index = data.index('haproxy')
      message = data[message_start_index..-1]
      Haproxy2Rpm.logger.debug "RECEIVED (syslog): #{message}"
      Haproxy2Rpm.rpm.process_and_send(message)
    end
  end
end
