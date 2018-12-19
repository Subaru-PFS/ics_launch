# Run (source, actually) a script for $host/$user, where:
#  - the scripts are under /software/hosts
#  - directory names are matched to the longest matching prefix of the hostname

user=$(id -un)
host=$(hostname -s)
doRun=true

HOSTDIR=/software/pfs_launch/hosts

usage() {
    echo "usage: $0 [-n] [-u USER] [-h HOST]" 1>&2
    echo "    -n    -- echo, but do not execute script" 1>&2
    exit 1
}

while getopts 'nu:h:?' opt; do
    case $opt in
        n)
            doRun=false
            ;;
        u)
            user=${OPTARG}
            ;;
        h)
            host=${OPTARG}
            ;;
        ?)
            usage
            ;;
        *)
            echo "unknown argument: $opt" 1>&2
            usage
            ;;
    esac
done

if test -z "$user" -o -z "$host"; then
    echo "both user ($user) and host ($host) must be specified" 1>&2
    usage
fi

fullHost=$host
while test -n "$host"; do
    if test -d $HOSTDIR/$host; then
        hostDir=$HOSTDIR/$host
        break
    fi
    host=$(echo -n $host | sed 's/.$//') # ${host:0:-1}
done

# For now, require a hostname match. Maybe add default later
if test -z "$hostDir"; then
    echo "no host directory in $HOSTDIR found to match $fullHost" 1>&2
    exit 2
fi

# Require an exact username match
if test ! -r $hostDir/$user; then
    echo "no user script for $user in $hostDir/" 1>&2
    exit 3
fi

if $doRun; then
    . $hostDir/$user
else
    echo "DID NOT: source $hostDir/$user"
fi
