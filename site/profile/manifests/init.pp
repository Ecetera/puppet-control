class profile::base {
  class { '::ntp': }
}
class profile::puppetdb {
  class { '::puppetdb': }
  class { '::puppetdb::master::config': }
}
class profile::apache {
  class { '::apache': }
}
class profile::apache::wsgi inherits profile::apache {
  class { '::apache::mod::wsgi': }
}
class profile::java {
  class { '::jdk_oracle': }
}
class profile::jenkins {
  class { '::jenkins': }
}
class profile::mysql::server {
  class { '::mysql::server': }
  class { '::mysql::server::account_security': }
}
class profile::mysql::client {
  class { '::mysql::client': }
}
class profile::puppetboard {
  class { '::puppetboard': }
  class { '::puppetboard::apache::conf': }
  # A temporary hack needed for puppetboard
  file { '/etc/httpd/conf.d/puppetboard_wsgi.conf':
    content => 'WSGISocketPrefix ../../var/run/wsgi', }
}
class profile::elasticsearch {
  class { '::elasticsearch': }
  elasticsearch::instance { 'es-01': }
  elasticsearch::plugin { 'lmenezes/elasticsearch-kopf':
    module_dir => 'kopf',
    instances  => 'es-01',
  }
  class { '::curator': }
  curator::job { 'elasticsearch_cleanup':
    delete_older   => 90, 
    close_older    => 30, 
    optimize_older => 2,
    bloom_older    => 2, }
    # timeout        => 3600, } Not yet in the module
}
class profile::logstash {
  class { '::logstash': }
  logstash::configfile { 'central':
    source => 'puppet:///modules/profile/logstash/central.conf' }
  logstash::patternfile { 'extra_patterns':
    source => 'puppet:///modules/profile/logstash/extra_patterns' }
  file { '/etc/logstash/ssl.crt':
    source => 'puppet:///modules/profile/logstash/ssl.crt', }
  file { '/etc/logstash/ssl.key':
    source => 'puppet:///modules/profile/logstash/ssl.key', }
}
class profile::kibana {
  class {'::kibana': }
}
class profile::logstashforwarder {
  class { '::logstashforwarder': }
  logstashforwarder::file { 'syslog':
    paths  => [ '/var/log/messages' ],
    fields => { 'type' => 'syslog' },
  }
}
