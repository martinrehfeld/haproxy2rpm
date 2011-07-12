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

## Supported RPM features

* Response times in application server
* Error rate
* Queue time
* Apdex
* Histogram
* Web transactions

## Known issues

* Seems to stall after some time running
* Do not run with --daemonize when used inside monit.rc

## Roadmap

* Improved logging and debugging (-l, --log)
