#!/bin/bash
set -euxo pipefail

# Hashes and some bits from conda-forge's download_osx_sdk.sh script (BSD-3-Clause licensed)

# Default to installing 13.3 which is the default on conda-forge.
MACOSX_SDK_VERSION="${1:-13.3}"

echo "Downloading ${MACOSX_SDK_VERSION} SDK"

curl -L --output MacOSX${MACOSX_SDK_VERSION}.sdk.tar.xz "https://github.com/alexey-lysiuk/macos-sdk/releases/download/${MACOSX_SDK_VERSION}/MacOSX${MACOSX_SDK_VERSION}.tar.xz"

sdk_sha256=$(
    case "${MACOSX_SDK_VERSION}" in
        ("15.5") echo "5096f730e9935adbd99d4bb082c3c6c01c077d966405ee4ae45705521476332e" ;;
        ("14.5") echo "f6acc6209db9d56b67fcaf91ec1defe48722e9eb13dc21fb91cfeceb1489e57e" ;;
        ("13.3") echo "71ae3a78ab1be6c45cf52ce44cb29a3cc27ed312c9f7884ee88e303a862a1404" ;;
        ("12.3") echo "91c03be5399be04d8f6b773da13045525e01298c1dfff273b4e1f1e904ee5484" ;;
        ("11.3") echo "cd4f08a75577145b8f05245a2975f7c81401d75e9535dcffbb879ee1deefcbf4" ;;
        ("11.1") echo "68797baaacb52f56f713400de306a58a7ca00b05c3dc6d58f0a8283bcac721f8" ;;
        ("11.0") echo "d3feee3ef9c6016b526e1901013f264467bb927865a03422a9cb925991cc9783" ;;
        ("10.15") echo "ac75d9e0eb619881f5aa6240689fce862dcb8e123f710032b7409ff5f4c3d18b" ;;
        ("10.14") echo "123dcd2e02051bed8e189581f6eea1b04eddd55a80f98960214421404aa64b72" ;;
        ("10.13") echo "1d2984acab2900c73d076fbd40750035359ee1abe1a6c61eafcd218f68923a5a" ;;
        ("10.12") echo "b314704d85934481c9927a0450db1768baf9af9efe649562fcb1a503bb44512f" ;;
        ("10.11") echo "d080fc672d94f95eb54651c37ede80f61761ce4c91f87061e11a20222c8d00c8" ;;
        ("10.10") echo "3839b875df1f2bc98893b8502da456cc0b022c4666bc6b7eb5764a5f915a9b00" ;;
        ("10.9") echo "fcf88ce8ff0dd3248b97f4eb81c7909f2cc786725de277f4d05a2b935cc49de0" ;;
        (*) echo "Unknown version & hash, please update conda-forge-ci-setup's download_osx_sdk.sh" ;;
    esac)

echo "${sdk_sha256} *MacOSX${MACOSX_SDK_VERSION}.sdk.tar.xz" | shasum -a 256 -c

SDKROOT="$(dirname "${SDKROOT}")/MacOSX${MACOSX_SDK_VERSION}.sdk"

mkdir -p "${SDKROOT}"

# Delete existing SDK, or symlink , e.g. MacOSX15.5.sdk -> MacOSX.sdk
rm -rf "${SDKROOT}"
tar -xf MacOSX${MACOSX_SDK_VERSION}.sdk.tar.xz -C "$(dirname "${SDKROOT}")"
