class m8_gpe::compiler {
    $path = "${m8_gpe::target}/compiler/bin"

    m8_gpe::source { 'compiler':
        source => 'https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7',
        type   => git,
    }

    file { "${path}/python":
        ensure  => symlink,
        target  => '/usr/bin/python2.7',
        require => M8_gpe::Source['compiler'],
    }
}
