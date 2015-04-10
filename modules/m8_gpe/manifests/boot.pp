class m8_gpe::boot {
    $img = "${m8_gpe::target}/boot.img"

    class { 'm8_gpe::dt': }

    exec { 'repack-boot.img':
        command  => "${m8_gpe::mkbootimg::mkbootimg} --kernel ${m8_gpe::ruu::source_dir}/boot.img-zImage --ramdisk ${m8_gpe::ruu::source_dir}/boot.img-ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x3b7 ehci-hcd.park=3' --base 0 --pagesize 2048 --kernel_offset 0x00008000 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt ${m8_gpe::dt::img} -o ${img}",
        creates  => $img,
        require  => [
            Class['m8_gpe::dt'],
            Class['m8_gpe::ruu'],
        ],
    }
}
