# Use the project conda/python, and a shared ../local/bin
#
PATH=/software/conda/bin:/software/local/bin:/software/pfs_launch/bin:$PATH

# Use "default/" EUPS and not a specific version.
# Use the MHS eups by default, not the DRP version.
#
. /software/mhs/products/eups/default/bin/setups.sh
declare -fx setup unsetup

setupForHost()
{
. setupProd.sh "$@"
}
declare -fx setupForHost

# Get the basics (oneCmd.py, mainly)
#
setup tron_actorcore
