ics_launch basics
-----------------

To state the obvious: PFS contains many hosts running many
programs. In operation we want the configuration to be predictable and
repeatable, and in development and during debugging flexible without
affecting the stable machines. ``ics_launch`` furthers this by putting
the rules and exceptions in one place. 

The project uses ``eups`` to control the versions of the running
programs, and all PFS software is available under
``/software``. ``ics_launch`` adds a very small number of PFS-specific
rules and features to eups:

- ``/software/ics_launch/bin/setup.sh`` is the single bash script which
  *all* users should source (in .bash_profile, say) to configure PFS
  EUPS software. This sets the python and EUPS environments and adds a
  single shell function (``setupForHost``) which adds the exception
  logic xto the EUPS ``setup`` function.

- ``/software/ics_launch/hosts/`` is a tree of per-host, per-user
  scripts to be run on boot. These replace the usual ``/etc/rc.local``
  things. The recommended way to run these is by adding ``@reboot
  /software/ics_launch/bin/launchFor.sh`` to the user crontabs which
  need to run a program on boot. ``launchFor.sh`` simply uses ``$USER``
  and ``hostname -s`` to find what script in
  ``/software/ics_lauch/hosts/`` to run.

- ``/software/ics_launch/versions.txt`` lists all the eups version
  exceptions for PFS. Regardless of whether any exceptions are listed,
  the default version of a given product is setup (i.e. ``setup
  $product`` is always run). ``versions.txt`` lines are:
  ``hostname product overrideProduct overrideVersion``, and indicate
  that when setting up the given ``$product`` on the given ``$hostname``,
  that the ``$overrideProduct`` will be set up with its
  ``$overrideVersion``. The lines are operated on in order.
    
- ``/software/ics_launch/bin/setupProd.sh`` is the additional script
  which applies the ``versions.txt`` exceptions to the eups ``setup``
  function. By default it uses ``hostname -s`` to index into the
  exceptions, but that can also be set with ``-H host``.

- The ``setupForHost`` shell function added by ``setup.sh`` arranges for
  the output of ``setupProd.sh`` to be sourced into the current
  shell. In general ``setupForHost`` is the only additional command
  which PFS users will need to know about. You can specify ``-v`` to
  print what is done, ``-n`` to not actually _do_ anything, or ``-H host``
  to override the hostname used to pick up exceptions.

Hostname matching is actually done by prefix: the ``bee/pfs-data`` host
script matches ``bee-b1``, etc.

NOT DONE
--------

This is a crude start. There are several things which still need to be
worked on:

- Only the canonical hostname (``hostname -s``) is used. That is
  probably fine at Subaru, but can be insufficient elsewhere, where
  you might want to run the archiver on the same host as tron, say.
- the only host scripts in use are the two for the bees and the one
  for ``tron``.
- Things can be cleaned up when the ``stageManager start`` ticket is done.
- ``rsyslog`` and ``logger`` calls needed. Badly.
- Along with that, diagnostics are awful. or non-existent.
