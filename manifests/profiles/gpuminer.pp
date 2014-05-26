class miner::profiles::gpuminer (	) {

    $packages_dep1= ['libcurl4-openssl-dev','automake', 'pkg-config', 'libtool',]

# Install all depending packages so we are able to compile sgminer
    package {$packages_dep1:
        ensure => installed,
    }

}