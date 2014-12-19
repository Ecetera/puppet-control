class profile::base {
  class { '::ntp': }
  class { '::sensu': }
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
  class { '::curator': }
  create_resources(elasticsearch::instance, hiera('es_instances'))
  create_resources(elasticsearch::plugin, hiera('es_plugins'))
  create_resources(curator::job, hiera('curator_jobs'))
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
  class { '::kibana': }
}
class profile::logstashforwarder {
  class { '::logstashforwarder': }
  logstashforwarder::file { 'syslog':
    paths  => [ '/var/log/messages' ],
    fields => { 'type' => 'syslog' },
  }
}
class profile::rabbit {
  class { '::rabbitmq': }
  class { '::uchiwa': }
  package { 'redis': ensure => installed }
  service { 'redis': ensure => running }
  rabbitmq_vhost { '/sensu':
    ensure => present, }
  rabbitmq_user { 'sensu':
    admin    => true,
    password => 'sensu', }
  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*', }
}
