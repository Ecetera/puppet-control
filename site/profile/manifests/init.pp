class profile::base {
  class { '::ntp': }
  class { '::sensu': }
  class { '::mcollective': }
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
  class { '::puppetboard::apache::vhost': }
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
  Apache::Vhost { port => '80', }
  file { '/opt/kibana/app/dashboards/default.json':
    source => 'puppet:///modules/profile/kibana/logstash.json', }
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
  rabbitmq_plugin { 'rabbitmq_stomp':
    ensure => present, }
  package { 'redis': ensure => installed }
  service { 'redis': ensure => running }
  rabbitmq_user { 'admin':
    ensure   => present,
    admin    => true,
    password => 'admin', }
}
class profile::sensu::server {
  class { '::uchiwa': }
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
class profile::mco::client {
  rabbitmq_vhost { '/mcollective':
    ensure => present, }
  rabbitmq_user { 'mcollective':
    admin    => false,
    password => 'marionette', }
  rabbitmq_user_permissions { 'mcollective@/mcollective':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*', }
  rabbitmq_user_permissions { 'admin@/mcollective':
    configure_permission => '.*', }
  rabbitmq_exchange { 'mcollective_broadcast@/mcollective':
    ensure   => present,
    type     => 'topic',
    user     => 'admin',
    password => 'admin', }
  rabbitmq_exchange { 'mcollective_directed@/mcollective':
    ensure   => present,
    type     => 'direct',
    user     => 'admin',
    password => 'admin', }
}
