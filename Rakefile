require 'bundler/gem_tasks'

require 'rake/testtask'

task :default => ['test:units']

namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.libs << "test"
    t.test_files = FileList['test/*_test.rb']

    t.verbose = true
  end

  desc 'send udp log lines for testing purposes'
  task :send_udp_log_lines do
    port = ENV['port'] || 3333
    status_code = ENV['status_code'] || 200
    uri = ENV['uri'] || '/'
    puts 'make sure the udp server is running'

    `yes '<13>May 19 18:30:17 haproxy[674]: 127.0.0.1:33319 [15/Oct/2003:08:31:57] relais-http Srv1 6559/100/7/147/6723 #{status_code} 243 - - ---- 1/3/5 0/0 "PUT #{uri} HTTP/1.0"' | nc -u -i 1 localhost #{port}`
  end
end
