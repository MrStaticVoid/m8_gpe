class m8_gpe::dt {
    $img = "${m8_gpe::target}/dt.img"

    class { 'm8_gpe::kernel': }
    class { 'm8_gpe::compiler': }
    class { 'm8_gpe::dtbtool': }

    exec { 'make-dtbs':
        command     => '/usr/bin/make dtbs',
        path        => "${m8_gpe::compiler::path}:/usr/bin:/bin",
        cwd         => "${m8_gpe::kernel::source_dir}",
        refreshonly => true,
        subscribe   => Class['m8_gpe::kernel'],
        require     => Class['m8_gpe::compiler'],
    }

    exec { 'remove-old-dt.img':
        command     => "/bin/rm -f ${img}",
        refreshonly => true,
        subscribe   => Exec['make-dtbs'],
    }

    exec { 'make-dt.img':
        command => "${m8_gpe::dtbtool::binary} -s 2048 -d 'htc,project-id = <' -o ${img} -p ${m8_gpe::kernel::source_dir}/scripts/dtc/ ${m8_gpe::kernel::source_dir}/arch/arm/boot/",
        creates => $img,
        require => [
            Class['m8_gpe::dtbtool'],
            Exec['remove-old-dt.img'],
        ],
    }
}
