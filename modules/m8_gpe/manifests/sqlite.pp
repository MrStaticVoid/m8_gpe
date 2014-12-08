class m8_gpe::sqlite {
    $source_dir = "${m8_gpe::target}/sqlite"
    $binary     = "${source_dir}/sqlite3"

    m8_gpe::source { 'sqlite':
        source => 'http://www.sqlite.org/2014/sqlite-autoconf-3080702.tar.gz',
        type   => tar,
    }

    #
    # Yes, it sucks to hard code the path to the compiler here, but the
    # whole point is just to show that there's nothing up my sleeves.
    # This could easily be replaced by a precompiled binary.
    #
    exec { 'compile-sqlite':
        command => "/usr/bin/armv6j-hardfloat-linux-gnueabi-gcc -static -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION sqlite3.c shell.c -o ${binary}",
        cwd     => $source_dir,
        creates => $binary,
        require => M8_gpe::Source['sqlite'],
    }
}
