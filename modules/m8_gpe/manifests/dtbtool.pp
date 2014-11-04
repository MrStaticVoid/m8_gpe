class m8_gpe::dtbtool {
    $source_dir = "${m8_gpe::target}/dtbtool/dtbtool"
    $binary     = "${source_dir}/dtbtool"

    m8_gpe::source { 'dtbtool':
        source => 'https://github.com/MrStaticVoid/android_device_qcom_common.git',
        type   => git,
    }

    exec { 'compile-dtbtool':
        command => "/usr/bin/cc ${source_dir}/dtbtool.c -o ${binary}",
        creates => $binary,
        require => M8_gpe::Source['dtbtool'],
    }
}
