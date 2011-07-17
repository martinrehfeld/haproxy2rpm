config.routes = [
  { :pattern => %r{^/[0-9]+/update$}, :target => '/user/update'},
  { :pattern => %r{^/project/[0-9]+$}, :target => '/project/show'}
]