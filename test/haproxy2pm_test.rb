$LOAD_PATH.unshift( File.dirname(__FILE__) )

require 'test_helper'

def log_entry(options)
  defaults = {
                :tq => 6559,
                :tw => 100,
                :tc => 7,
                :tr => 147,
                :tt => 6723,
                :status_code => 200,
                :uri => '/',
                :http_method => 'GET'
            }
  defaults.merge!(options)
  log_line = <<LOG_LINE
haproxy[674]: 127.0.0.1:33319 [15/Oct/2003:08:31:57] relais-http Srv1 #{defaults[:tq]}/#{defaults[:tw]}/#{defaults[:tc]}/#{defaults[:tr]}/#{defaults[:tt]} #{defaults[:status_code]} 243 - - ---- 1/3/5 0/0 "#{defaults[:http_method]} #{defaults[:uri]} HTTP/1.0"
LOG_LINE
end

class Haproxy2RpmTest < Test::Unit::TestCase
  context 'parsing of haproxy files' do
    setup do
      @line = File.open(File.join(File.dirname(__FILE__), 'fixtures', 'haproxy.log')){|f| f.readlines}.first
      @result = Haproxy2Rpm::LineParser.new(@line)
    end

    should 'parse the Tq (total time in ms spent waiting for client)' do
     assert_equal 6559, @result.tq
    end

    # this is the time waiting in the global queue
    should 'parse the Tw (total time in ms spent waiting in queue)' do
      assert_equal 100, @result.tw
    end

    should 'parse the Tc (total time in ms spent waiting for the connection to the final server' do
      assert_equal 7, @result.tc
    end

    # this is the response time of your application server
    should 'parse the Tr (total time in ms spent waiting for server to send full HTTP response)' do
      assert_equal 147, @result.tr
    end

    should 'parse the Tt (total time in ms spent between accept and close' do
      assert_equal 6723, @result.tt
    end

    should 'parse the status code' do
      assert_equal 200, @result.status_code
    end

    should 'parse the http method' do
      assert_equal 'PUT', @result.http_method
    end

    should 'parse the uri' do
      assert_equal '/user/login', @result.uri
    end
  end

  context 'is_error' do
   should 'return false for redirects' do
      assert !Haproxy2Rpm::LineParser.new(log_entry(:status_code => 302)).is_error?
    end

    should 'return false for 200 OK' do
      assert !Haproxy2Rpm::LineParser.new(log_entry(:status_code => 200)).is_error?
    end

  
    should 'return false for 404' do
      assert !Haproxy2Rpm::LineParser.new(log_entry(:status_code => 404)).is_error?
    end

    should 'return for 500 and above' do
      assert Haproxy2Rpm::LineParser.new(log_entry(:status_code => 500)).is_error?
    end

  end
end
