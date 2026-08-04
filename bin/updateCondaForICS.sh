#!/bin/bash

# Add all additional python packages to base DRP conda environment which ICS needs to run. See INSTRM-2992.

# Do these in chunks, because `conda list -r` does not show what was actually *requested*, and qt can
# pull in all sorts of stuff.
EXTRA_PKGS_1="ply twisted cython dnspython gitpython sep pyserial"
EXTRA_PKGS_1="${EXTRA_PKGS_1} gitdb rfc5424-logging-handler pika sysv_ipc"

EXTRA_PKGS_2="pyqt qt5reactor"

# Products not in conda/conda-forge:
PIP_PKGS="fysom"

# Use conda install, because mamba install can fail if another user has installed packages before.
echo "installing ${EXTRA_PKGS_1}...."
conda install $EXTRA_PKGS_1

echo "installing ${EXTRA_PKGS_2}...."
conda install --use-index-cache $EXTRA_PKGS_2

echo "installing pip packages ${PIP_PKGS}...."
pip install $PIP_PKGS
