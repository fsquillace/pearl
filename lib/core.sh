#!/bin/bash


AUR_URL='http://aur.archlinux.org/'
AUR_SEARCH_URL="$AUR_URL/rpc.php?"

function search(){
    # Search a package into the repository
    local DATA=$(wget -q -O - "${AUR_SEARCH_URL}type=search&arg=yaourt")
}


# Read PKGBUILD
# PKGBUILD must be in current directory
# Usage:	read_pkgbuild ($update)
#	$update: 1: call devel_check & devel_update from makepkg
# Set PKGBUILD_VARS, exec "eval $PKGBUILD_VARS" to have PKGBUILD content.
read_pkgbuild() {
    local vars=(pkgbase pkgname pkgver pkgrel arch pkgdesc provides url \
        groups license source install md5sums depends makedepends conflicts \
        replaces \
        _svntrunk _svnmod _cvsroot_cvsmod _hgroot _hgrepo \
        _darcsmod _darcstrunk _bzrtrunk _bzrmod _gitroot _gitname \
    )

    unset ${vars[*]}
    local ${vars[*]}

}


function install_package(){
    # Usage: install_package <packagename>
    # $1: name of the package
    
    # Before starting ensure that the PKGBUILD variables are reset
    local vars=(pkgbase pkgname pkgver pkgrel arch pkgdesc provides url \
        groups license source install md5sums depends makedepends conflicts \
        replaces \
        _svntrunk _svnmod _cvsroot_cvsmod _hgroot _hgrepo \
        _darcsmod _darcstrunk _bzrtrunk _bzrmod _gitroot _gitname \
    )
    unset ${vars[*]}
    local ${vars[*]}

    # Store the original working directory
    origin_wd=$(pwd)

    local pkgname=$1

    local maindir=$PEARL_TEMPORARY/pearl_pkg_${pkgname}_$(date +"%Y%m%d-%H%M%S")
    local srcdir=$maindir/src
    local pkgdir=$maindir/pkg

    mkdir -p $srcdir
    mkdir -p $pkgdir

    cd $maindir
    wget "$AUR_URL/packages/ya/yaourt/yaourt.tar.gz"

    # Extract the PKGBUILD&co in the main directory
    tar -xzvf ${pkgname}.tar.gz
    mv $pkgname/* . && rm -fr $pkgname
    
    source PKGBUILD

    echo "Getting source files..."
    for (( i=0; i<${#source[@]}; i++ ))
    do
        local s=${source[i]}

        echo "Downloading $s ..."
        wget -P $srcdir $s
        local sourcename=$(basename $s)

        # Check sum for each file downloaded
        echo "Checking sum..."
        if [ ! -z $md5sums ]; then
            # Checks the length between source and md5sums array
            [ ${#source[@]} -eq ${#md5sums[@]} ] || \
            echo "Error: The source and md5sums variables didn't have the same lenght."

            local sum=$(md5sum $srcdir/$sourcename | awk '{print $1}')
            if [ $sum != "${md5sums[i]}" ]; then
                echo "Error: Not a correct checksum for $sourcename" 
                return 1
            fi
        fi

        echo "Extracting..."
        atool -f --extract-to=$srcdir $srcdir/$sourcename
    done



    # TODO manage the dependencies of the package


    echo "Building..."
    build
    echo "Packaging..."
    package



    # TODO check conflicts between the package and its dependencies
    

    # Resets all PKGBUILD variables and returns to the original wd
    unset ${vars[*]}
    cd $origin_wd

}



function pearl(){
    #local TEMP=`getopt -o crwph --long case-sensitive,recursive,whole-words,pdf,help -n 'eye' -- "$@"`

    #if [ $? != 0 ] ; then echo "Error on parsing the command line. Try eye -h" >&2 ; return ; fi

    ## Note the quotes around `$TEMP': they are essential!
    #eval set -- "$TEMP"

    #local OPT_CASE="-i"
    #local OPT_RECUR="-maxdepth 1"
    #local OPT_WHOLE_WORDS=false
    #local OPT_PDF=false
    #local OPT_HELP=false
    #while true ; do
	#case "$1" in
	    #-c|--case-sensitive) OPT_CASE="" ; shift ;;
	    #-r|--recursive) OPT_RECUR="" ; shift ;;
	    #-w|--whole-words) OPT_WHOLE_WORDS=true ; shift ;;
            #-p|--pdf) OPT_PDF=true ; shift ;;
            #-h|--help) OPT_HELP=true ; shift ;;
            #--) shift ; break ;;
	    #*) echo "Internal error!" ; return ;;
	#esac
    #done


    #if $OPT_HELP
    #then
        #echo "Usage: eye [options] [path] pattern"
        #echo "Options:"
        #echo "-h, --help            show this help message and exit"
        #echo "-c, --case-sensitive  Case sensitive."
        #echo "-r, --recursive       Recursive."
        #echo "-w, --whole-words     Whole words."
        #echo "-p, --pdf             Search in .pdf files too."
        #return 0
    #fi


    #local args=()
    #for arg do
        #args+=($arg)
    #done

    #if [ ${#args[@]} -gt 2 ]; then
        #echo "Too many arguments!" ; return 127 ;
    #elif [ ${#args[@]} -eq 1 ]; then
        #local path=.
        #local keyword=${args[0]}
    #else
        #local path=${args[0]}
        #local keyword=${args[1]}
    #fi

    echo

}
