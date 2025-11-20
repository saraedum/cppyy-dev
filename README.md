# cppyy on conda-forge

cppyy is magic. But building cppyy is a mess. It vendors parts of root, a
patched copy of cling, and a patched LLVM and all that in a very confusing
repository setup that makes it extremely challenging to package.

I guess I'm stuck with being the conda-forge maintainer of all this for the
foreseeable future so at least I want to make my life a bit easier by having
some reproducible setups here that I can use to check how I managed to build
older versions.

# How to use this Repository

TODO

# cppyy Repository Layout and Build Process

## cppyy-cling

See `upstream/cppyy-backend/cling`, the following is relative to that directory.

### What is this?

cppyy-cling is just a patched Cling built against a patched LLVM. Cling itself
is normally built against a patched LLVM so cppyy just patches it a bit more.

Cling is part of the ROOT project, so cppyy-cling uses its own
`create_src_directory.py` to copy upstream's `root/interpreter/` into
`src/interpreter/` here and to apply some patches to it; most of what's in
`patches/`. (The result of this is what you get when you download the sdist of
`cppyy-cling`.)

There's some more stuff already in `src/`. This seems to serve several purposes:
* Generic ROOT machinery that is needed to make Cling build (see the standalone
  repository at https://github.com/root-project/cling.)
* Generic ROOT machinery that `cppyy-backend` builds against.
* Dependencies of some Python entrypoints that live in `python/`, see below.

cppyy-cling also provides some (Python) executables that are not normally part of Cling [2]. Namely
* `cling-config`, purely Python to produce compiler flags and such.
* `rootcling` (calls `src/main/rootcling.cxx`) a thin wrapper around the
  standard
  [rootcling](https://root.cern/d/interacting-shared-libraries-rootcling.html) [1]
* `genreflex`, essentially the same as `rootcling` [3]
* `cppyy-generator`, a helper for the opinionated [cmake
  machinery](https://cppyy.readthedocs.io/en/stable/cmake_interface.html?highlight=cmake#cmake-interface-1)
  that can be used to ship binding packages.

[1]: cppyy uses rootcling to generate precompiled headers (PCH) when first
imported, see
https://cppyy.readthedocs.io/en/stable/installation.html?highlight=alldict#precompiled-header.

[2]: See https://cppyy.readthedocs.io/en/stable/utilities.html for details on these entrypoints.

[3]: Not used by cppyy; probably just provided because it's a Cling thing and
an old tutorial (GSL Pythonization Tutorial) refers to it.

### Build Process

Everything is driven by a complicated `setup.py`. Essentially, `cmake` builds
LLVM and Cling, installs it, and then also installs the utilities in `python/`.

## cppyy-backend

See `upstream/cppyy-backend/clingwrapper`, the following is relative to that directory.
(This is what you get when you download the sdist of `cppyy-backend`.)

### What is this?

TODO

## CPyCppyy

TODO

## cppyy

TODO
