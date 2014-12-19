class role {
  include profile::base
  include profile::logstashforwarder
  #include profile::sensu::client
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
  include profile::sensu::server
}
class role::jenkins inherits role {
  include profile::jenkins
}
