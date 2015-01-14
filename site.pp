# TODO

node default {
  hiera_include('role')
}

#node /puppet/ { include role::puppetserver }
#node /elk/ { include role::elk }
#node /mon/ { include role::mon }
