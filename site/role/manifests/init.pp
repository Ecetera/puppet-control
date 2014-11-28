class role {
  include profile::base
  include profile::logstashforwarder
}
class role::puppetserver inherits role {
  include profile::puppetdb
  include profile::apache::wsgi
  include profile::puppetboard
}
class role::elk inherits role {
  include profile::elasticsearch
  include profile::logstash
  include profile::kibana
}
