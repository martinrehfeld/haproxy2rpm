# Agent#record_transaction
# lib/new_relic/agent.rb
# NewRelic::Agent.record_transaction( params['value'].to_f, params )
# lib/new_relic/rack.rb
# test/rpm_agent_test.rb
# NewRelic::Agent.record_transaction 0.5, 'uri' => "/users/create?foo=bar"
# NewRelic::Agent.record_transaction rand(100) / 100.0, {'metric' => 'Controller/josef'}

def record_transaction(duration_seconds, options={})
  is_error = options['is_error'] || options['error_message'] ||
options['exception']
  metric = options['metric']
  metric ||= options['uri'] # normalize this with url rules
  raise "metric or uri arguments required" unless metric
  metric_info =
NewRelic::MetricParser::MetricParser.for_metric_named(metric)

  if metric_info.is_web_transaction?
    NewRelic::Agent::Instrumentation::MetricFrame.record_apdex(metric_info,
duration_seconds, duration_seconds, is_error)
    histogram.process(duration_seconds)
  end
  metrics = metric_info.summary_metrics

  metrics << metric
  metrics.each do |name|
    stats = stats_engine.get_stats_no_scope(name)
    stats.record_data_point(duration_seconds)
  end

  if is_error
    if options['exception']
      e = options['exception']
    elsif options['error_message']
      e = Exception.new options['error_message']
    else
      e = Exception.new 'Unknown Error'
    end
    error_collector.notice_error e, :uri => options['uri'],
:metric => metric
  end
  # busy time ?
end

