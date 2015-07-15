define m8_gpe::ota (
    $version = $name,
    $source,
) {
    $zip        = "${m8_gpe::target}/m8_gpe-ota-${version}.zip"
    $source_dir = "${m8_gpe::target}/ota-${version}"

    m8_gpe::source { "ota-${version}":
        source => $source,
        type   => zip,
    }

    m8_gpe::source { "firmware-${version}":
        source  => "${source_dir}/firmware.zip",
        type    => zip,
        require => M8_Gpe::Source["ota-${version}"],
    }

    m8_gpe::boot { $version:
        source_dir => "${m8_gpe::target}/firmware-${version}",
        target_dir => $source_dir,
        require    => M8_gpe::Source["firmware-${version}"],
    }

    file { [
        "${source_dir}/firmware.zip",
        "${source_dir}/META-INF/CERT.RSA",
        "${source_dir}/META-INF/CERT.SF",
        "${source_dir}/META-INF/MANIFEST.MF",
        "${source_dir}/META-INF/com/android",
    ]:
        ensure  => absent,
        force   => true,
        require => M8_gpe::Source["firmware-${version}"],
        notify  => Exec["remove-old-zip-ota-${version}"],
    }

    file { "${source_dir}/META-INF/com/google/android/updater-script":
        source  => "puppet:///modules/m8_gpe/ota/updater-script-${version}",
        require => M8_gpe::Source["ota-${version}"],
        notify  => Exec["remove-old-zip-ota-${version}"],
    }

    exec { "remove-old-zip-ota-${version}":
        command     => "/bin/rm -f ${zip}",
        refreshonly => true,
        subscribe   => M8_gpe::Boot[$version],
    }

    exec { "zip-ota-${version}":
        command => "/usr/bin/zip -r ${zip} .",
        cwd     => $source_dir,
        creates => $zip,
        require => Exec["remove-old-zip-ota-${version}"],
    }
}
