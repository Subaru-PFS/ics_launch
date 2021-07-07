# Maybe not the right place or necessary, but averts some problems.
umask 2
# set the envvar OMP_NUM_THREADS=1 to ensure numpy doesn’t use threads deep down, causing contention.
export OMP_NUM_THREADS=1

# Setup DRP + partial_MHS environment.

# For accounts other than pfs, wrap all this in
#    if  $(hostname -s) == "shell2-ics"; then
#    fi

source scl_source enable devtoolset-8 rh-git218
source /software/drp-5.2/loadLSST.bash
conda deactivate
conda activate "$LSST_CONDA_ENV_NAME"
setup -v pfs_pipe2d

# Append MHS eups product roor to the DRP root. Note that this way,
# new product installs wil be to the DRP tree.
#
# Also note that the python executable and environment will be from
# DRP. Since the only product which needs both words is a simple actor
# that seemed like the right choice. But note that the DRP miniconda
# is pretty mini.

EUPS_PATH=$EUPS_PATH:/software/mhs/products
setup ics_launch

# The workhorse script, which simply scans versions.txt for version to
# override for a given host+product.
#
setupForHost()
{
. $ICS_LAUNCH_DIR/bin/setupProd.sh "$@"
}
declare -fx setupForHost

