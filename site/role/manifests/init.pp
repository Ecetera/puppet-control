class role {
  include profile::ntp
  include profile::sensu
  include profile::mcollective
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
class role::mon inherits role {
  include profile::rabbit
  include profile::sensu::server
  include profile::mco::client
}
class role::jenkins inherits role {
  include profile::jenkins
}
