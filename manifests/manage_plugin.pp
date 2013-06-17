define teamcity::manage_plugin($data_directory, $plugin = $title, $restart = false) {

  validate_re($plugin,['^(.)+$'], 'Plugin name must not be empty')
  validate_bool($restart)
  validate_string($plugin)

  file { "Ensure-${plugin}-present":
    ensure  => file,
    path    => "${data_directory}/plugins/${plugin}",
    source  => "puppet:///modules/teamcity/${plugin}",
  }

  if ($restart == true) {
    exec {"restart-teamcity-to-install-${plugin}" :
      command   => 'command goes here to actually restart',
      require   => File["Ensure-${plugin}-present"],
      logoutput => true,
    }
  } elseif ($restart == false) {
    exec {'notify-about-new-plugin-installation-only' :
      command   => 'command here to do something other than restart',
      require   => File["Ensure-${plugin}-present"],
      logoutput => true,
    }
  }
}
