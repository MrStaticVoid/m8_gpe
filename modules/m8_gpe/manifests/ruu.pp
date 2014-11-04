class m8_gpe::ruu {
    $source_dir = "${m8_gpe::target}/ruu"
    $boot_img   = "${source_dir}/boot.img"
    $system_img = "${source_dir}/system.img"

    class { 'm8_gpe::mkbootimg': }
    class { 'm8_gpe::dt': }

    m8_gpe::source { 'ruu':
        source => 'https://thestaticvoid.com/dist/m8_gpe/sources/RUU-HTC_One_M8_GPE_4.4.4-2.12.1700.1.zip',
        type   => zip,
    }

    exec { 'unpack-boot.img':
        command     => "${m8_gpe::mkbootimg::unpackbootimg} -i ${boot_img}",
        cwd         => "${source_dir}",
        refreshonly => true,
        subscribe   => M8_gpe::Source['ruu'],
        require     => Class['m8_gpe::mkbootimg'],
    }

    exec { 'repack-boot.img':
        command     => "${m8_gpe::mkbootimg::mkbootimg} --kernel ${source_dir}/boot.img-zImage --ramdisk ${source_dir}/boot.img-ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 ehci-hcd.park=3' --base 0 --pagesize 2048 --kernel_offset 0x00008000 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt ${m8_gpe::dt::img} -o ${boot_img}",
        refreshonly => true,
        subscribe   => [
            Class['m8_gpe::dt'],
            Exec['unpack-boot.img'],
        ],
    }
}
