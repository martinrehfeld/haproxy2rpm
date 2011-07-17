# Push haproxy logs to newrelic rpm
This is useful for languages where newrelic does not provide an agent,
such as erlang or node.js based applications.

It runs in syslog mode or tail a log file.

## Installation

gem install haproxy2rpm or clone it

* copy your newrelic.yml file to $HOME/.newrelic/newrelic.yml
* or set $NRCONFIG to point to your newrelic.yml file

Tell haproxy to log to syslog. e.g:

    # /etc/haproxy/haproxy.cfg
    global
      log 127.0.0.1:3333   daemon

## Running it
    haproxy2rpm /path/to/logfile 
    haproxy2rpm --syslog
    haproxy2rpm --syslog --daemonize
    haproxy2rpm --syslog -c /path/to/config/file.rb

## Configuration

Check the examples folder

## Supported RPM features

* Response times in application server
* Error rate
* Queue time
* Apdex
* Histogram
* Web transactions

## Known issues

* Daemonize is broken. Does not work nicely with new relic agent
 
## Roadmap

* Working daemonized mode
* remove haproxy dependency and make it a more generic rpm recorder that
  works over syslog and log files. This would allow to send custom messages to rpm by just sending log lines through syslog. The haproxy part would be more of a strategy. That means we need to make it easyly extendible without forking or creating a new gem
