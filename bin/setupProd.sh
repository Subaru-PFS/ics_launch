OIFS=$IFS
trap 'IFS=$OIFS' EXIT

actor=$1; shift

# Use getopts and make hostname require -s
hostname=$1; shift
if test -z "$hostname"; then
    hostname=$(/bin/hostname -s)
fi

args="$@"

if test -z "$actor"; then
    echo "usage: $0 actorName hostName" 1>&2
    return 1
fi

# Make life a bit easier by always setting up the current version first.
#
setup $args $actor

# Error checking is non-existant. Bad, Loomis.
#
IFS=$(echo)
for versionLine in $(egrep "^$hostname *$actor" /software/pfs_launch/versions.txt); do
    eval $(echo $versionLine | cut -d' ' -f1-2 --complement | awk "{print \"setup $args \" \$0}")
done
