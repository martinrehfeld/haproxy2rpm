# Push haproxy logs to newrelic rpm
This is useful for languages where newrelic does not provide an agent,
such as erlang or node.js based applications

## Installation

* copy your newrelic.yml file to $HOME/.newrelic/newrelic.yml
* or set $NRCONFIG to point to your newrelic.yml file

## Running it
haproxy2rpm /path/to/logfile

## Analyzing it

At the moment, it only works with custom views

<verbatim>
  <h3>Charts</h3>
  <table width='100%'>
    <tr>
    <td>line_chart {% line_chart value:'average_value' title:'Test' metric:'Controllers/main/login' %}</td>
  </tr>

  </table>
</verbatim/>
