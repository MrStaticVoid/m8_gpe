class m8_gpe::build {
    $dir = "${m8_gpe::target}/build"

    m8_gpe::source { 'digitalhigh':
        source => 'https://thestaticvoid.com/dist/m8_gpe/GPE_M8VZW_080714_DH.zip',
        type   => zip,
    }

    m8_gpe::source { 'supersu':
        source => 'https://thestaticvoid.com/dist/m8_gpe/UPDATE-SuperSU-v2.16.zip',
        type   => zip,
    }

    m8_gpe::source { 'busybox':
        source => 'http://www.busybox.net/downloads/binaries/latest/busybox-armv7l',
    }

    # This is from http://michael.gorven.za.net/blog/2013/11/25/statically-linked-e2fsprogs-binaries-android
    m8_gpe::source { 'e2fsprogs':
        source => 'https://thestaticvoid.com/dist/m8_gpe/e2fsprogs-android-static-1.42.8-main.tar.xz',
        type   => tar,
    }

    class { 'm8_gpe::ruu': }

    file { [
        $dir,
        "${dir}/META-INF",
        "${dir}/META-INF/com",
        "${dir}/META-INF/com/google",
        "${dir}/META-INF/com/google/android",
        "${dir}/tools",
        "${dir}/apps",
        "${dir}/supersu",
    ]:
        ensure => directory,
    }

    file { "${dir}/META-INF/com/google/android/update-binary":
        source  => "${m8_gpe::target}/digitalhigh/META-INF/com/google/android/update-binary",
        mode    => '0755',
        require => M8_gpe::Source['digitalhigh'],
    }

    file { "${dir}/META-INF/com/google/android/updater-script":
        source => 'puppet:///modules/m8_gpe/updater-script',
    }

    file { "${dir}/boot.img":
        source  => $m8_gpe::ruu::boot_img,
        require => Class['m8_gpe::ruu'],
    }

    file { "${dir}/system.img":
        source  => $m8_gpe::ruu::system_img,
        require => Class['m8_gpe::ruu'],
    }

    file { "${dir}/tools/resize2fs":
        source  => "${m8_gpe::target}/e2fsprogs/resize2fs",
        require => M8_gpe::Source['e2fsprogs'],
    }

    file { "${dir}/tools/fsck.ext4":
        source  => "${m8_gpe::target}/e2fsprogs/resize2fs",
        require => M8_gpe::Source['e2fsprogs'],
    }

    file { "${dir}/tools/busybox":
        source  => "${m8_gpe::sources_dir}/busybox",
        require => M8_gpe::Source['busybox'],
    }

    file { "${dir}/apps/Torch.apk":
        source  => "${m8_gpe::target}/digitalhigh/system/app/Torch.apk",
        require => M8_gpe::Source['cm'],
    }

    file { "${dir}/supersu/installer":
        source  => "${m8_gpe::target}/supersu/META-INF/com/google/android/update-binary",
        require => M8_gpe::Source['supersu'],
    }

    file { "${dir}/supersu/supersu.zip":
        source  => "${m8_gpe::sources_dir}/supersu.zip",
        require => M8_gpe::Source['supersu'],
    }

    file { "${dir}/build.prop.extra":
        source => 'puppet:///modules/m8_gpe/build.prop.extra',
    }

    file { "${dir}/init.extra":
        source => 'puppet:///modules/m8_gpe/init.extra',
    }
}
