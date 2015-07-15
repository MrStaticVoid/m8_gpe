define m8_gpe::source (
    $source,
    $type = none,
    $fetch = true,
) {
    $ext = $type ? {
        none    => '',
        default => ".${type}"
    }

    $dest = $fetch ? {
        false   => $source,
        default => "${m8_gpe::sources_dir}/${name}${ext}",
    }

    $target = "${m8_gpe::target}/${name}"

    if $source =~ /^\// {
        $fetch_command = "/bin/cp ${source} ${dest}"
    } else {
        $fetch_command = $type ? {
            git     => "/usr/bin/git clone --bare ${source} ${dest}",
            default => "/usr/bin/wget ${source} -O ${dest}",
        }
    }

    exec { "fetch-${name}":
        command => $fetch_command,
        timeout => 0,
        creates => $dest,
    }

    exec { "remove-old-${name}":
        command     => "/bin/rm -rf ${target}",
        refreshonly => true,
        subscribe   => Exec["fetch-${name}"],
    }

    case $type {
        zip, tar: {
            file { $target:
                ensure  => directory,
                require => Exec["remove-old-${name}"],
            }

            $extract_command = $type ? {
                zip => "/usr/bin/unzip ${dest} || /bin/true",
                tar => "/bin/tar --strip-components=1 -xvf ${dest}",
            }

            exec { "extract-${name}":
                command     => $extract_command,
                cwd         => $target,
                refreshonly => true,
                subscribe   => [
                    Exec["fetch-${name}"],
                    File[$target],
                ],
            }
        }

        git: {
            exec { "clone-${name}":
                command => "/usr/bin/git clone ${dest} ${target}",
                creates => $target,
                require => Exec["remove-old-${name}"],
            }
        }
    }
}
