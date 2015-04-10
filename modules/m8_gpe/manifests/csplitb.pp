class m8_gpe::csplitb {
    $binary     = "${m8_gpe::target}/csplitb/csplitb.py"

    m8_gpe::source { 'csplitb':
        source => 'https://github.com/MrStaticVoid/csplitb.git',
        type   => git,
    }
}
