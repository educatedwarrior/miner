class miner::profiles::gpuminer (	) {

    $packages_dep1= ['libcurl4-openssl-dev','automake', 'pkg-config', 'libtool']

    $git_repository="https://github.com/prettyhatemachine/sph-sgminer.git"
    $miner_dir="/root/sph-sgminer"

    $ADL_SDK_file="ADL_SDK_6.0.zip"
    $ADL_SDK_url="https://sites.google.com/site/cryptoculture/files/${ADL_SDK_file}"

    # Install all depending packages so we are able to compile sgminer
    package {$packages_dep1:
        ensure => installed,
    }

    # Clone mining software
    exec { "clone_sgminer":
        command => "/usr/bin/git clone $git_repository",
        creates => $miner_dir,
        #path    => "/usr/local/bin/:/bin/",
        cwd =>    "/root"   ,
        # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
        # require => [Package[$packages_dep1],Package[$packages_dep2]],
    }

    # Clone mining software
    exec { "get_ADL_SDK":
        command => "/usr/bin/wget ${ADL_SDK_url}",
        creates => "/root/${ADL_SDK_file}",
        #path    => "/usr/local/bin/:/bin/",
        cwd =>    "/root"   ,
        # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
        # require => [Package[$packages_dep1],Package[$packages_dep2]],
    }



}