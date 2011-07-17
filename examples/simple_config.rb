class MyRequestParser
  def initialize(line)
    @line = line.to_i
  end
  
  def value_in_seconds
    @line / 1000.0
  end
  
  def value
    @line
  end
  
  def is_error?
    false
  end
end

config.message_parser = lambda do |line|
  MyRequestParser.new(line)
end

config.request_recorder = lambda do |request|
  params = {
    'metric' => "Controller/my/request"
  }
  
  if request.is_error?
    params['is_error'] = true
    params['error_message'] = "Something went wrong"
  end
  
  # record a new relic transaction
  record_transaction(request.value, params)
  
  # record a custom metric for new relic custom views
  result = stats_engine.get_stats_no_scope('Custom/my_custom').record_data_point(request.value)
  Haproxy2Rpm.logger.debug "RECORDING (data point): #{result.inspect}"
  
end