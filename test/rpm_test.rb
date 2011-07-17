$LOAD_PATH.unshift( File.dirname(__FILE__) )

require 'test_helper'

class RpmTest < Test::Unit::TestCase
  
  context 'initialize' do
    setup do
      NewRelic::Agent.stubs(:manual_start)
    end
    
    should 'start the new relic agent' do
      NewRelic::Agent.expects(:manual_start)
      Haproxy2Rpm::Rpm.new({})
    end
    
    should 'aquire the stats engine' do
      stats_engine = mock
      NewRelic::Agent.agent.expects(:stats_engine).returns(stats_engine)
      stats_engine.expects(:get_stats_no_scope).with('WebFrontend/QueueTime')
      Haproxy2Rpm::Rpm.new({})
    end
  end
  context '#process_and_send' do
    setup do
      NewRelic::Agent.stubs(:manual_start)
      @instance = Haproxy2Rpm::Rpm.new({})
    end
    
    should 'record the transaction time' do
      NewRelic::Agent.expects(:record_transaction).with(0.1, any_parameters)
      @instance.process_and_send(log_entry(:tr => 100))
    end
    
    should 'record the controller metric' do
      NewRelic::Agent.expects(:record_transaction).with(anything, has_entry('metric', 'Controller/user/check'))
      @instance.process_and_send(log_entry(:http_path => "/user/check"))
    end
    
    should 'consider routes' do
      @instance.routes = [{:pattern => %r{^/[0-9]+/update$}, :target => '/user/update'}]
      NewRelic::Agent.expects(:record_transaction).with(anything, has_entry('metric', 'Controller/user/update'))
      @instance.process_and_send(log_entry(:http_path => "/49339032093/update"))
    end
        
    should 'record the queue time' do
      stats = mock
      @instance.queue_time_stats_engine = stats
      stats.expects(:record_data_point).with(0.01)
      @instance.process_and_send(log_entry(:tw => 10))
    end
  end
  
  context '#message_parser=' do
    setup do
      NewRelic::Agent.stubs(:manual_start)
      @instance = Haproxy2Rpm::Rpm.new({})
      @instance.request_recorder = lambda{|r|}
    end
    
    should 'allow to pass in a custom message parser' do
      parser = lambda{|r|}
      @instance.message_parser = parser
      parser.expects(:call)
      @instance.process_and_send(log_entry)
    end
  end
  
  context '#request_recorder=' do
    setup do
      NewRelic::Agent.stubs(:manual_start)
      @instance = Haproxy2Rpm::Rpm.new({})
      @instance.message_parser = lambda{ |line| line }
    end
    
    should 'allow to pass in a custom recorder' do
      recorder = lambda{|r|}
      @instance.request_recorder = recorder
      recorder.expects(:call)
      @instance.process_and_send(log_entry)
    end
  end
  
  context 'config_file' do
    setup do
      NewRelic::Agent.stubs(:manual_start)
      @instance = Haproxy2Rpm::Rpm.new({:config_file => File.join(File.dirname(__FILE__), 'fixtures', 'config.rb')})
    end
    
    should 'eval the passed in config file' do
      stats = mock
      @instance.stats_engine.expects(:get_stats_no_scope).with('Custom/dummy').returns(stats)
      stats.expects(:record_data_point).with(12)
      @instance.process_and_send('12')
    end
  end
end