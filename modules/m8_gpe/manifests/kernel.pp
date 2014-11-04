class m8_gpe::kernel {
    $source_dir = "${m8_gpe::target}/kernel"

    m8_gpe::source { 'kernel':
        source => 'https://github.com/MrStaticVoid/android_kernel_htc_msm8974.git',
        type   => git,
    }

    exec { 'make-kernel-defconfig':
        command     => '/usr/bin/make m8_defconfig',
        cwd         => $source_dir,
        refreshonly => true,
        subscribe   => M8_gpe::Source['kernel'],
    }
}
