# cppyy feedstocks

The subdirectories here corresponds to the projects that make up cppyy on conda-forge. Each subdirectory has a pixi/rattler setup, so you can have a look at pixi run to see the possible targets.

The typical workflow here is to make changes, run `pixi run rerender` and then try out the build with one of the `build-` targets.

Note that when cross-compiling you have to add `--target-platform=... --test skip` manually, e.g., `pixi run build-osx_arm64_python3.10.____cpython --target-platform=osx-arm64 --test skip` to cross compile for Silicon on non-Silicon.

To try out the artifacts on another machine, copy the entire output/ directory. It already has the shape of a local conda repository.

Then do `conda create -n deleteme --channel file:///path/to/output cppyy-cling` to install the local package with correct dependencies.

## macOS

For a macOS (x86_64) build you probably need to run `pixi run install-macos-sdk 10.13` first and then set ``SDKROOT="`dirname $(xcrun --show-sdk-path)`/MacOSX10.13.sdk"``.

Similarly, for arm64, but with `11.0` instead.
