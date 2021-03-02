# Use the project conda/python, and a shared ../local/bin
#
PATH=/software/conda/bin:/software/local/bin:$PATH
# This is the environment for the ICS software.
conda activate conda-ics

# Use "default/" EUPS and not a specific version.
# Use the MHS eups by default, not the DRP version.
#
. /software/mhs/products/eups/default/bin/setups.sh
declare -fx setup unsetup

# Get the basics (ourselves and oneCmd.py, mainly)
#
setup ics_launch
setup tron_actorcore

# The workhorse script, which simply scans versions.txt for version to
# override for a given host+product.
#
setupForHost()
{
. $ICS_LAUNCH_DIR/bin/setupProd.sh "$@"
}
declare -fx setupForHost

