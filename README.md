# Push haproxy logs to newrelic rpm
This is useful for languages where newrelic does not provide an agent,
such as erlang or node.js based applications

## Installation

gem install haproxy2rpm or clone it

* copy your newrelic.yml file to $HOME/.newrelic/newrelic.yml
* or set $NRCONFIG to point to your newrelic.yml file

## Running it
    haproxy2rpm /path/to/logfile 
    haproxy2rpm --syslog
    haproxy2rpm --syslog --daemonize

## Roadmap

* Adding error messages
* test behavior with / uri path
* test behavior with params
