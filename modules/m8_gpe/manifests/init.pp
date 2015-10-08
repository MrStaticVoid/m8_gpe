class m8_gpe (
    $target,
) {
    $sources_dir = "${target}/sources"

    file { $sources_dir:
        ensure => directory,
    }

    class { 'm8_gpe::ruu': }

    m8_gpe::ota { 'LMY47O.H5':
        source => 'http://android.clients.google.com/packages/ota/gpedogfood_htc_m8_generic/4eaf26db2c018451a068638bd01c6854a0eef0f1.OTA_M8_UL_L51_STOCK_UI_MR_Google_WWE_4.04.1700.5-4.04.1700.4_release_429773.zip',
    }

    m8_gpe::ota { 'LMY47O.H6':
        source => 'http://android.clients.google.com/packages/ota/gpedogfood_htc_m8_generic/47d86b52e0571cd645216fbbe7d7e404ecd4c3da.OTA_M8_UL_L51_STOCK_UI_MR_Google_WWE_4.04.1700.6-4.04.1700.5_release_430317.zip',
    }

    m8_gpe::ota { 'LMY47O.H9':
        source => 'http://android.clients.google.com/packages/ota/gpedogfood_htc_m8_generic/da03535cf104cb56194dd040661bd98b77764fca.OTA_M8_UL_L51_STOCK_UI_MR_Google_WWE_4.04.1700.9-4.04.1700.6_release_449381.zip',
    }

    m8_gpe::ota { 'LMY47O.H10':
        source => 'http://android.clients.google.com/packages/ota/gpedogfood_htc_m8_generic/5811554b908aa8d3ef756d1bf6702b704e7ccfd2.OTA_M8_UL_L51_STOCK_UI_MR_Google_WWE_4.04.1700.10-4.04.1700.9_release_453088.zip',
    }
}
