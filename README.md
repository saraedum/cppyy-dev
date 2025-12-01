# cppyy on conda-forge

cppyy is magic. But building cppyy is a mess. It vendors parts of root, a
patched copy of cling, and a patched LLVM and all that in a very confusing
repository setup that makes it extremely challenging to package.

I guess I'm stuck with being the conda-forge maintainer of all this for the
foreseeable future so at least I want to make my life a bit easier by having
some reproducible setups here that I can use to check how I managed to build
older versions.

This repository aims to make it easy to build and develop the four components
that make up cppyy (`cppyy-cling`, `cppyy-backend`, `CpyCppyy`, `cppyy`) in the
relevant variants.

# What is here?

* `upstream` are the upstream sources of the components of cppyy, namely,
  `cppyy-cling` and `cppyy-backend` (both in `upstream/cppyy-backend`),
  `Cpycppyy`, and `cppyy`.
* `feedstocks` are the upstream feedstocks from conda-forge.
* `patched` are staging areas used for building the patch chains to apply to
  the feedstocks. There is one branch for each upstream release; created by
  directly importing the release tarball and reflecting the latest sequence of
  conda-forge patches for that release. We aim to create a tag for each
  released sequence of patches.
* `downstream` are some downstream projects that we might want to test against
  the latest builds of cppyy

# How to use this Repository

This repository is organized in branches to reflect the releases of cppyy.

We aim to support the common development and maintenance tasks through pixi.

Note that the setup here is not fool proof. Built artifacts can leak between
runs, branches and environments. To be on the safe side, it's best to `pixi run clean`
which runs `git clean -fdx` everywhere.

## pixi Environments

We provide the following pixi environments:

* `feedstock-dev`, to work on the `feedstocks`/, see
  [there](feedstocks/README.md) for details
* `cppyy-cling-dev-builtin-llvm`, to work on `patched/cppyy-cling/` or
  `upstream/cppyy-backend/cling` configured to build its own cppyy-patched
  LLVM.
* `cppyy-cling-dev-conda-forge-llvm` same but using an LLVM build from conda-forge.
* `cppyy-backend-dev-conda-forge` to work on `patched/cppyy-backend` or
  `upstream/cppyy-backend/clingwrapper` with `cppyy-cling` provided by conda-forge.
* `cppyy-backend-dev-pypi` same but with `cppyy-cling` provided by PyPI.
* `cpycppyy-*`, same as the corresponding `cppyy-backend-dev-*` environments
* `cppyy-*`, same as the corresponding `cppyy-backend-dev-*` environments
* `dev-builtin-llvm`, to work on any of the `patched/` projects while providing all dependencies from there as well.
* `dev-conda-forge-llvm`, same as `dev-builtin-llvm` but using conda-forge's LLVM.
* `cppyy-pypi`, an installation of vanilla cppyy as published on PyPI
* `cppyy-conda-forge`, an installation of cppyy as published on conda-forge

## pixi Tasks

The environments provide a variety of tasks. They should be mostly
self-explanatory, see `pixi.toml` for details.

Here are some of the most important ones

### Generic Tasks

* `pixi run clean` -- to run `git clean -fdx` recursively in all submodules
* `pixi run reset` -- to run `git reset --hard` and update submodules in all submodules

### feedstock Tasks

TODO

### cppyy-cling-dev-* Tasks

* `pixi run install` -- to install `cppyy-cling` from `patched/cppyy-cling`
* `pixi run install-cppyy-cling-from-upstream` -- to install `cppyy-cling` from `upstream/cppyy-backend-cling`

### cppyy-backend-dev-* Tasks

* `pixi run install-cppyy-backend-from-pypi` -- to install the upstream `cppyy-backend` from PyPI assuming its dependencies are present
* `pixi run install-cppyy-backend-from-patched` -- to install `cppyy-backend` from `patched/cppyy-backend` assuming its dependencies are present
* `pixi run install-cppyy-backend-from-upstream` -- to install `cppyy-backend` from `upstream/cling/clingwrapper` assuming its dependencies are present
* `pixi run install` -- to install `cppyy-backend` and its dependencies from `patched/`

### cpycppyy-dev-* Tasks

* `pixi run install-cpycppyy-from-pypi` -- to install the upstream `cpycppyy` from PyPI assuming its dependencies are present
* `pixi run install-cpycppyy-from-patched` -- to install `cpycppyy` from `patched/cpycppyy` assuming its dependencies are present
* `pixi run install-cpycppyy-from-upstream` -- to install `cpycppyy` from `upstream/cpycppyy` assuming its dependencies are present
* `pixi run install` -- to install `cpycppyy` and its dependencies from `patched/`

### cppyy-dev-* Tasks

* `pixi run install-cppyy-from-pypi` -- to install the upstream `cppyy` from PyPI assuming its dependencies are present
* `pixi run install-cppyy-from-patched` -- to install `cppyy` from `patched/cppyy` assuming its dependencies are present
* `pixi run install-cppyy-from-upstream` -- to install `cppyy` from `upstream/cppyy` assuming its dependencies are present
* `pixi run install` -- to install `cppyy` and its dependencies from `patched/`
* `pixi run test` -- run pytest tests defined in `upstream/cppyy/test` assuming cppyy is installed already
* `pixi run install-flatsurf-suite` -- to install the flatsurf suite from `downstream/`
* `pixi run test-cppyythonizations` -- to run the cppyythonizations test suite from `downstream/`
* `pixi run install-cppyythonizations` -- to install `cppyythonizations` from `downstream/` assuming that its dependencies are already installed
* `pixi run test-gmpxxyy` -- to run the `gmpxxyy` test suite from `downstream/`
* `pixi run install-gmpxxyy` -- to install `gmpxxyy` from `downstream/`, assuming that its dependencies are already installed
* Same `install-*` and `test-*` for `e-antic`, `exact-real`, `intervalxt`, `flatsurf`, and `sage-flatsurf`

### dev-* Tasks

All of the above, except that `install` will install `cppyy-cling`, `cppyy-backend`, `CPyCppyy`, and `cppyy` from `patched/`.

# Upstream Repository Layout and Build Process

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
