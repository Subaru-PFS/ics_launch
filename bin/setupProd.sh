OIFS=$IFS
trap 'IFS=$OIFS' EXIT

# 
usage() {
    echo "usage: setupProd.sh [-n] [-v] [-H HOST] PRODUCT_NAME" 1>&2
    echo "    -n    -- echo, but do not execute script" 1>&2
    echo "    -v    -- verbose" 1>&2
}

doRun=true
verbose=false
unset OPTIND OPTARG OPTERR
while getopts 'nvH:h?' opt "$@"; do
    # echo "one arg: opt=$opt" 1>&2 
    case $opt in
        n)
            doRun=false
            ;;
        v)
            verbose=true
            ;;
        H)
            host=${OPTARG}
            ;;
        [h?])
            usageOnly=true
            ;;
        *)
            echo "unknown argument: $opt" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND-1))
actor=$1

if test -z "$host"; then
    host=$(/bin/hostname -s)
fi

# This script usually gets "source"d, so we do not want to exit
if test -z "$actor" -o -s "$usageOnly"; then
    usage
else
    if $verbose; then
        echo "setting up $actor for host $host" 1>&2
        eupsArgs="-v"
    fi

    # Make life a bit easier by always setting up the current version first.
    #
    if $doRun; then
        setup $eupsArgs $actor 1>&2
    else
        echo "NOT setting up: $eupsArgs $actor" 1>&2
    fi

    # Error checking is non-existant. Bad, Loomis.
    #
    OIFS=$IFS
    IFS=$'\n'
    for versionLine in $(egrep -s "^$host +$actor" /software/ics_launch/versions.txt); do
        setupString=$(IFS=$OIFS; echo "$versionLine" | cut -d' ' -f1-2 --complement | awk "{print \"setup $eupsArgs \" \$0}")
       if $verbose; then
            if ! $doRun; then
                prefix="NOT"
            fi
            echo "$prefix setting up: $setupString" 1>&2
        fi
        if $doRun; then
            eval $setupString 1>&2
        fi
    done
fi

