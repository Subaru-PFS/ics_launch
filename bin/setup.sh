# Use the project conda/python, and a shared ../local/bin
#
PATH=/software/conda/bin:/software/local/bin:$PATH

# Use "default/" EUPS and not a specific version.
# Use the MHS eups by default, not the DRP version.
#
. /software/mhs/products/eups/default/bin/setups.sh
declare -fx setup unsetup

# Get the basics (ourselves and oneCmd.py, mainly)
#
setup pfs_launch
setup tron_actorcore

setupForHost()
{
. $PFS_LAUNCH_DIR/bin/setupProd.sh "$@"
}
declare -fx setupForHost

