class m8_gpe (
    $target,
) {
    $sources_dir = "${target}/sources"
    $zip = "${target}/m8_gpe.zip"

    file { $sources_dir:
        ensure => directory,
    }

    class { 'm8_gpe::build': }

    exec { 'remove-old-zip':
        command     => "/bin/rm -f ${zip}",
        refreshonly => true,
        subscribe   => Class['m8_gpe::build'],
    }

    exec { 'zip':
        command => "/usr/bin/zip -r ${zip} .",
        cwd     => $m8_gpe::build::dir,
        creates => $zip,
        require => Exec['remove-old-zip'],
    }
}
