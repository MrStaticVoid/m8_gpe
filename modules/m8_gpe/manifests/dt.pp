define m8_gpe::dt (
    $version = $name,
    $boot_img_dir,
    $img,
) {
    $dir = "${m8_gpe::target}/dt-${version}"

    include m8_gpe::csplitb
    include m8_gpe::dtbtool
    include m8_gpe::mkbootimg

    exec { "unpack-boot-${version}.img":
        command     => "${m8_gpe::mkbootimg::unpackbootimg} -i boot.img",
        cwd         => "${boot_img_dir}",
        creates     => "${boot_img_dir}/boot.img-dtb",
        require     => Class['m8_gpe::mkbootimg'],
    }

    file { [
        $dir,
        "${dir}/dtb-split",
        "${dir}/dts",
        "${dir}/dtb-modified",
    ]:
        ensure => directory,
    }

    exec { "split-boot-dtb-${version}":
        command     => "${m8_gpe::csplitb::binary} --number 2 --suffix .dtb d00dfeed ${boot_img_dir}/boot.img-dtb",
        cwd         => "${dir}/dtb-split",
        refreshonly => true,
        subscribe   => File["${dir}/dtb-split"],
        require     => [
            Class['m8_gpe::csplitb'],
            Exec["unpack-boot-${version}.img"],
        ],
    }

    exec { "decompile-dtbs-${version}":
        command     => "for dtb in *.dtb; do /usr/bin/dtc -I dtb -O dts -o ${dir}/dts/\$dtb.dts \$dtb; done",
        cwd         => "${dir}/dtb-split",
        refreshonly => true,
        subscribe   => Exec["split-boot-dtb-${version}"],
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
    exec { "modify-dts-${version}":
        command     => '/bin/sed -ri \'s/(0x10f (0x. 0x10000))/0x10a \2 0x10b \2 \1/g\' *.dts',
        cwd         => "${dir}/dts",
        unless      => '/bin/grep "0x10a 0x. 0x10000" *.dts',
        require     => Exec["decompile-dtbs-${version}"],
    }

    exec { "compile-modified-dts-${version}":
        command     => "for dts in *.dts; do /usr/bin/dtc -I dts -O dtb -o ${dir}/dtb-modified/\$dts.dtb \$dts; done",
        cwd         => "${dir}/dts",
        refreshonly => true,
        subscribe   => Exec["modify-dts-${version}"],
        provider    => shell,
    }

    exec { "remove-old-dt-${version}.img":
        command     => "/bin/rm -f ${img}",
        refreshonly => true,
        subscribe   => Exec["compile-modified-dts-${version}"],
    }

    exec { "make-dt-${version}.img":
        command => "${m8_gpe::dtbtool::binary} -s 2048 -d 'htc,project-id = <' -o ${img} -p /usr/bin/ ${dir}/dtb-modified/",
        creates => $img,
        require => [
            Class['m8_gpe::dtbtool'],
            Exec["remove-old-dt-${version}.img"],
        ],
    }
}
