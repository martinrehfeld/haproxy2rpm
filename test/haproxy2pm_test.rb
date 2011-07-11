$LOAD_PATH.unshift( File.dirname(__FILE__) )

require 'test_helper'

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
end
