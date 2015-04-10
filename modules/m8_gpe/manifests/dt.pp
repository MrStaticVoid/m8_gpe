class m8_gpe::dt {
    $dir = "${m8_gpe::target}/dt"
    $img = "${dir}/dt.img"

    class { 'm8_gpe::ruu': }
    class { 'm8_gpe::csplitb': }
    class { 'm8_gpe::dtbtool': }

    file { [
        $dir,
        "${dir}/dtb-split",
        "${dir}/dts",
        "${dir}/dtb-modified",
    ]:
        ensure => directory,
    }

    exec { 'split-boot-dtb':
        command     => "${m8_gpe::csplitb::binary} --number 2 --suffix .dtb d00dfeed ${m8_gpe::ruu::source_dir}/boot.img-dtb",
        cwd         => "${dir}/dtb-split",
        refreshonly => true,
        subscribe   => File["${dir}/dtb-split"],
        require     => [
            Class['m8_gpe::csplitb'],
            Class['m8_gpe::ruu'],
        ],
    }

    exec { 'decompile-dtbs':
        command     => "for dtb in *.dtb; do /usr/bin/dtc -I dtb -O dts -o ${dir}/dts/\$dtb.dts \$dtb; done",
        cwd         => "${dir}/dtb-split",
        refreshonly => true,
        subscribe   => Exec['split-boot-dtb'],
        provider    => shell,
    }

    #
    # Transform lines like:
    #
    #   htc,project-id = <0x10f 0x0 0x10000 ...
    #
    # to:
    #
    #   htc,project-id = <0x10a 0x0 0x10000 0x10f 0x0 0x10000 ...
    #
    exec { 'modify-dts':
        command     => '/bin/sed -ri \'s/(0x10f (0x. 0x10000))/0x10a \2 \1/g\' *.dts',
        cwd         => "${dir}/dts",
        unless      => '/bin/grep "0x10a 0x. 0x10000" *.dts',
        require     => Exec['decompile-dtbs'],
    }

    exec { 'compile-modified-dts':
        command     => "for dts in *.dts; do /usr/bin/dtc -I dts -O dtb -o ${dir}/dtb-modified/\$dts.dtb \$dts; done",
        cwd         => "${dir}/dts",
        refreshonly => true,
        subscribe   => Exec['modify-dts'],
        provider    => shell,
    }

    exec { 'remove-old-dt.img':
        command     => "/bin/rm -f ${img}",
        refreshonly => true,
        subscribe   => Exec['compile-modified-dts'],
    }

    exec { 'make-dt.img':
        command => "${m8_gpe::dtbtool::binary} -s 2048 -d 'htc,project-id = <' -o ${img} -p /usr/bin/ ${dir}/dtb-modified/",
        creates => $img,
        require => [
            Class['m8_gpe::dtbtool'],
            Exec['remove-old-dt.img'],
        ],
    }
}
