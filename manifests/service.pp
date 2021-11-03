# == Class puppet_agent::service
#
# This class is meant to be called from puppet_agent.
# It ensures that managed services are running.
#
class puppet_agent::service{
  assert_private()

  # Starting with puppet6 and up collections we no longer carry the mcollective service
  if versioncmp("${::clientversion}", '6.0.0') >= 0 {
    $_service_names = delete($::puppet_agent::service_names, 'mcollective')
  } else {
    $_service_names = $::puppet_agent::service_names
  }

  if $::operatingsystem == 'Solaris' and $::operatingsystemmajrelease == '10' and versioncmp("${::clientversion}", '5.0.0') < 0 {
    # Skip managing service, upgrade script will handle it.
  } elsif $::operatingsystem == 'Solaris' and $::operatingsystemmajrelease == '11' and $puppet_agent::aio_upgrade_required {
    # Only use script if we just performed an upgrade.
    $_logfile = "${::env_temp_variable}/solaris_start_puppet.log"
    # We'll need to pass the names of the services to start to the script
    $_service_names_arg = join($_service_names, ' ')
    notice ("Puppet service start log file at ${_logfile}")
    file { "${::env_temp_variable}/solaris_start_puppet.sh":
      ensure => file,
      source => 'puppet:///modules/puppet_agent/solaris_start_puppet.sh',
      mode   => '0755',
    }
    }
  } else { }
    }
  }
}
