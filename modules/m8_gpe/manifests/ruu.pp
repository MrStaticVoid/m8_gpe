class m8_gpe::ruu {
    $source_dir = "${m8_gpe::target}/ruu"
    $boot_img   = "${source_dir}/boot.img"
    $system_img = "${source_dir}/system.img"

    class { 'm8_gpe::mkbootimg': }

    m8_gpe::source { 'ruu':
        source => 'https://thestaticvoid.com/dist/m8_gpe/sources/RUU-HTC_One_M8_GPE_5.1-4.04.1700.4.zip',
        type   => zip,
    }

    exec { 'unpack-boot.img':
        command     => "${m8_gpe::mkbootimg::unpackbootimg} -i ${boot_img}",
        cwd         => "${source_dir}",
        refreshonly => true,
        subscribe   => M8_gpe::Source['ruu'],
        require     => Class['m8_gpe::mkbootimg'],
    }
}
