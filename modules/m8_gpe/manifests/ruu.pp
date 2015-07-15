class m8_gpe::ruu {
    $zip        = "${m8_gpe::target}/m8_gpe-ruu.zip"
    $source_dir = "${m8_gpe::target}/ruu"
    $target_dir = "${m8_gpe::target}/build-ruu"
    $boot_img   = "${source_dir}/boot.img"
    $system_img = "${source_dir}/system.img"

    include 'm8_gpe::mkbootimg'

    m8_gpe::source { 'ruu':
        source => 'https://thestaticvoid.com/dist/m8_gpe/sources/RUU-HTC_One_M8_GPE_5.1-4.04.1700.4.zip',
        type   => zip,
    }

    class { 'm8_gpe::build':
        dir     => $target_dir,
        require => M8_gpe::Source['ruu'],
    }

    m8_gpe::boot { 'ruu':
        source_dir => $source_dir,
        target_dir => $target_dir,
        require    => Class['m8_gpe::build'],
    }

    exec { 'remove-old-zip-ruu':
        command     => "/bin/rm -f ${zip}",
        refreshonly => true,
        subscribe   => [
            M8_gpe::Boot['ruu'],
            Class['m8_gpe::build'],
        ]
    }

    exec { 'zip-ruu':
        command => "/usr/bin/zip -r ${zip} .",
        cwd     => $m8_gpe::build::dir,
        creates => $zip,
        require => Exec['remove-old-zip-ruu'],
    }
}
