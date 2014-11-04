class m8_gpe::mkbootimg {
    $source_dir    = "${m8_gpe::target}/mkbootimg"
    $mkbootimg     = "${source_dir}/mkbootimg"
    $unpackbootimg = "${source_dir}/unpackbootimg"

    m8_gpe::source { 'mkbootimg':
        source => 'https://github.com/MrStaticVoid/mkbootimg.git',
        type   => git,
    }

    exec { 'make-mkbootimg':
        command => '/usr/bin/make',
        cwd     => $source_dir,
        creates => $mkbootimg,
        require => M8_gpe::Source['mkbootimg'],
    }
}
