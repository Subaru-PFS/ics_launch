# Use the project conda/python, and a shared ../local/bin
#
PATH=/software/conda/bin:/software/local/bin:$PATH

# Use "default/" EUPS and not a specific version.
# Use the MHS eups by default, not the DRP version.
#
source /software/mhs/products/eups/default/bin/setups.sh

# Get the basics (oneCmd.py, mainly)
#
setup tron_actorcore
