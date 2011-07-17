class DummyRequest
  def initialize(line)
    @line = line
  end
  
  def value
    @line.to_i
  end
end

config.message_parser = lambda do |line|
  DummyRequest.new(line)
end

config.request_recorder = lambda do |request|
  stats_engine.get_stats_no_scope('Custom/dummy').record_data_point(request.value)
end