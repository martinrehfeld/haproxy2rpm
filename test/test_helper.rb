$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), "..", "lib") )

require "rubygems"
require 'test/unit'
require 'mocha'
require 'shoulda-context'
require 'haproxy2rpm'


ENV['NRCONFIG'] = File.join(File.dirname(__FILE__), '..', 'newrelic.yml')

class DummyLogger
  [:level, :debug, :info, :warn, :fatal, :error].each do |method|
    define_method(method) do |*args|
    end
  end
end
Haproxy2Rpm.logger = DummyLogger.new

def log_entry(options = {})
  defaults = {
                :tq => 6559,
                :tw => 100,
                :tc => 7,
                :tr => 147,
                :tt => 6723,
                :status_code => 200,
                :http_path => '/',
                :http_method => 'GET',
                :http_query => 'example_param=test',
            }
  defaults.merge!(options)
  log_line = <<LOG_LINE
haproxy[674]: 127.0.0.1:33319 [15/Oct/2003:08:31:57] relais-http Srv1 #{defaults[:tq]}/#{defaults[:tw]}/#{defaults[:tc]}/#{defaults[:tr]}/#{defaults[:tt]} #{defaults[:status_code]} 243 - - ---- 1/3/5 0/0 "#{defaults[:http_method]} #{defaults[:http_path]}#{defaults[:http_query] ? "?#{defaults[:http_query]}" : ''} HTTP/1.0"
LOG_LINE
end
