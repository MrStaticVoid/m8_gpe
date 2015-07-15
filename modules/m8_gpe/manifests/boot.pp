define m8_gpe::boot (
    $version = $name,
    $source_dir,
    $target_dir,
) {
    $img = "${target_dir}/boot.img"
    $dt_img = "${source_dir}/dt.img"

    m8_gpe::dt { $version:
        boot_img_dir => $source_dir,
        img          => $dt_img,
    }

    exec { "repack-boot-${version}.img":
        command     => "${m8_gpe::mkbootimg::mkbootimg} --kernel ${source_dir}/boot.img-zImage --ramdisk ${source_dir}/boot.img-ramdisk.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=30 msm_rtb.filter=0x3b7 ehci-hcd.park=3' --base 0 --pagesize 2048 --kernel_offset 0x00008000 --ramdisk_offset 0x02000000 --tags_offset 0x01e00000 --dt ${dt_img} -o ${img}",
        refreshonly => true,
        subscribe   => M8_gpe::Dt[$version],
    }
}
