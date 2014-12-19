# TODO

#node default {
#  include ::role
#}

node /puppet/ { include role::puppetserver }
node /elk/ { include role::elk }
node /mon/ { include role::mon }

#node /adm\d+$/ { include role::admin }
#node /app\d+$/ { include role::app }
#node /db\d+$/ { include role::db }
#node /solr\d+$/ { include role::solr }
#node /web\d+$/ { include role::web }
#node srgpreldb01 { include role::db::master }
#node srgpreldb02 { include role::db::slave }
