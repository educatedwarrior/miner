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

    $ADL_SDK_dir="/root/ADL_SDK"
    #Make sure obj directory exists before compiling
    if ! defined(File[$ADL_SDK_dir]) {
        file { $ADL_SDK_dir:
                ensure => "directory",
                owner  => "root",
                group  => "root",
                mode   => 775,
                alias => "create_dir_ADL_SDK_${name}",
                #require => Exec["clone_repository_${name}"],
                before => Exec["get_ADL_SDK"],
        }
    }


    # Get ADL SDK
    exec { "get_ADL_SDK":
        command => "/usr/bin/wget ${ADL_SDK_url}",
        creates => "${ADL_SDK_dir}/${ADL_SDK_file}",
        #path    => "/usr/local/bin/:/bin/",
        cwd =>    $ADL_SDK_dir   ,
        notify => Exec["unzip_ADL_SDK"] ,
        # path    => [ "/usr/local/bin/", "/bin/" ],  # alternative syntax
        # require => [Package[$packages_dep1],Package[$packages_dep2]],
    }

    # Unzip ADL SDK
    exec { "unzip_ADL_SDK":
        command => "/usr/bin/7z x ${ADL_SDK_dir}/${ADL_SDK_file}",
        cwd =>    $ADL_SDK_dir   ,
        refreshonly => true ,
        notify => Exec["copy_ADL_SDK"],
        require => Exec["get_ADL_SDK"] ,
    }

    # Copy ADL SDK files for build
    exec { "copy_ADL_SDK":
        command => "/bin/cp ${ADL_SDK_dir}/include/*.h /root/sph-sgminer/ADL_SDK",
        cwd =>    "${ADL_SDK_dir}/include"   ,
        refreshonly => true ,
        require => Exec["unzip_ADL_SDK"] ,
    }



}