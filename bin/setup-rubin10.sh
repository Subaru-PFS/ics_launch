# Maybe not the right place or necessary, but averts some problems.
umask 2

# Use the project conda/python, and a shared ../local/bin
#
PATH=/software/bin:/software/local/bin:$PATH

# <<< conda initialize <<<
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/software/stack_2025-06-13/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/software/stack_2025-06-13/conda/etc/profile.d/conda.sh" ]; then
        . "/software/stack_2025-06-13/conda/etc/profile.d/conda.sh"
    else
        export PATH="/software/stack_2025-06-13/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate rubin10-ics

# Use "default/" EUPS and not a specific version.
# Use the MHS eups by default, not the DRP version.
#
. /software/mhs/products/eups/default/bin/setups.sh
declare -fx setup unsetup

# Get the basics (ourselves and oneCmd.py, mainly)
#
setup ics_launch
setup tron_actorcore
setup pfs_instdata

# The workhorse script, which simply scans versions.txt for version to
# override for a given host+product.
#
setupForHost()
{
. $ICS_LAUNCH_DIR/bin/setupProd.sh "$@"
}
declare -fx setupForHost

