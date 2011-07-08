# Push haproxy logs to newrelic rpm
This is useful for languages where newrelic does not provide an agent,
such as erlang or node.js based applications

## Installation

gem install haproxy2rpm or clone it

* copy your newrelic.yml file to $HOME/.newrelic/newrelic.yml
* or set $NRCONFIG to point to your newrelic.yml file

## Running it
haproxy2rpm /path/to/logfile or ./bin/haproxy2rpm /path/to/log/file

## Analyzing it

At the moment, it only works with custom views

<verbatim>
  <h3>Charts</h3>
  <table width='100%'>
    <tr>
    <td>line_chart {% line_chart value:'average_value' title:'Test' metric:'Custom/HAProxy/response_times' %}</td>
  </tr>

  </table>
</verbatim/>


## Roadmap

* daemonize option
* syslog (udp maybe tcp) server with https://github.com/melito/em-syslog and then point HaProxy to that port. Why touch the disk if we don't have to?
* Figure out how to report rpms and response times so that they show up inside the newrelic application view and not only as a custom metric
