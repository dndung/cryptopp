#!/usr/bin/env bash

# ====================================================================
# Sets the cross compile environment for ARM Embedded
#
# Written by Jeffrey Walton, noloader gmail account
#
# Crypto++ Library is copyrighted as a compilation and (as of version 5.6.2)
# licensed under the Boost Software License 1.0, while the individual files
# in the compilation are all public domain.
#
# This script only supports Ubuntu at the moment. It does not support Fedora.
# See http://www.cryptopp.com/wiki/ARM_Embedded_(Command_Line) for details.
# ====================================================================

# set -eu

# Unset old options

unset IS_CROSS_COMPILE

unset IS_IOS
unset IS_ANDROID
unset IS_ARM_EMBEDDED
unset ARM_EMBEDDED_FLAGS

export ARM_EMBEDDED_TOOLCHAIN="/home/dungdn/workspace/src/s905_kern49/toolchain/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin"
export ARM_EMBEDDED_SYSROOT="/home/dungdn/workspace/sdk/usr/aarch64-linux-gnu/sysroot"

if [ -z "${ARM_EMBEDDED_TOOLCHAIN-}" ]; then
	ARM_EMBEDDED_TOOLCHAIN="/usr/bin"
fi

if [ ! -d "$ARM_EMBEDDED_TOOLCHAIN" ]; then
	echo "ARM_EMBEDDED_TOOLCHAIN is not valid"
	[ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

# Fedora
# TOOL_PREFIX="arm-linux-gnu"

# Ubuntu
TOOL_PREFIX="aarch64-linux-gnu"

export CPP="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-cpp"
export CC="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-gcc"
export CXX="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-g++"
export LD="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-ld"
export AR="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-ar"
export AS="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-as"
export RANLIB="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-ranlib"
# export RANLIB="$ARM_EMBEDDED_TOOLCHAIN/$TOOL_PREFIX-gcc-ranlib-4.7"

# Test a few of the tools
if [ ! -e "$CPP" ]; then
  echo "ERROR: CPP is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$CC" ]; then
  echo "ERROR: CC is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$CXX" ]; then
  echo "ERROR: CXX is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$AR" ]; then
  echo "ERROR: AR is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$AS" ]; then
  echo "ERROR: AS is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$RANLIB" ]; then
  echo "ERROR: RANLIB is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -e "$LD" ]; then
  echo "ERROR: LD is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

# The Crypto++ Makefile uses these to disable host settings like
#   IS_LINUX or IS_DARWIN, and incorporate settings for ARM_EMBEDDED
export IS_ARM_EMBEDDED=1

# GNUmakefile-cross uses these to to set CXXFLAGS for ARM_EMBEDDED
if [ -z "$ARM_EMBEDDED_SYSROOT" ]; then
  export ARM_EMBEDDED_SYSROOT="/usr/arm-linux-gnueabi"
fi

if [ ! -d "$ARM_EMBEDDED_SYSROOT" ]; then
  echo "ERROR: ARM_EMBEDDED_SYSROOT is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

# Fix C++ header paths for Ubuntu
# ARM_EMBEDDED_TOOLCHAIN_VERSION="4.7.3"
ARM_EMBEDDED_TOOLCHAIN_VERSION="6.3.1"
#ARM_EMBEDDED_CXX_HEADERS="$ARM_EMBEDDED_SYSROOT/include/c++/$ARM_EMBEDDED_TOOLCHAIN_VERSION"
ARM_EMBEDDED_CXX_HEADERS="/home/dungdn/workspace/src/s905_kern49/toolchain/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/aarch64-linux-gnu/include/c++/$ARM_EMBEDDED_TOOLCHAIN_VERSION"

if [ ! -d "$ARM_EMBEDDED_CXX_HEADERS" ]; then
  echo "ERROR1: ARM_EMBEDDED_CXX_HEADERS is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

if [ ! -d "$ARM_EMBEDDED_CXX_HEADERS/aarch64-linux-gnu" ]; then
  echo "ERROR2: ARM_EMBEDDED_CXX_HEADERS is not valid"
  [ "$0" = "$BASH_SOURCE" ] && exit 1 || return 1
fi

# Finally, the flags...
# export ARM_EMBEDDED_FLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -Wl,--fix-cortex-a8 -I$ARM_EMBEDDED_CXX_HEADERS -I$ARM_EMBEDDED_CXX_HEADERS/arm-linux-gnueabi"

# Add additional flags below, like -mcpu=cortex-m3.
export ARM_EMBEDDED_FLAGS="-I$ARM_EMBEDDED_CXX_HEADERS -I$ARM_EMBEDDED_CXX_HEADERS/aarch64-linux-gnu"
if [ -z "$ARM_EMBEDDED_FLAGS" ]; then
  export ARM_EMBEDDED_FLAGS="-I$ARM_EMBEDDED_CXX_HEADERS -I$ARM_EMBEDDED_CXX_HEADERS/aarch64-linux-gnu"
fi

# And print stuff to wow the user...
VERBOSE=1
if [ ! -z "$VERBOSE" ] && [ "$VERBOSE" -ne 0 ]; then
  echo "CPP: $CPP"
  echo "CXX: $CXX"
  echo "AR: $AR"
  echo "LD: $LD"
  echo "RANLIB: $RANLIB"
  echo "ARM_EMBEDDED_TOOLCHAIN: $ARM_EMBEDDED_TOOLCHAIN"
  echo "ARM_EMBEDDED_CXX_HEADERS: $ARM_EMBEDDED_CXX_HEADERS"
  echo "ARM_EMBEDDED_FLAGS: $ARM_EMBEDDED_FLAGS"
  echo "ARM_EMBEDDED_SYSROOT: $ARM_EMBEDDED_SYSROOT"
fi

echo
echo "*******************************************************************************"
echo "It looks the the environment is set correctly. Your next step is build"
echo "the library with 'make -f GNUmakefile-cross'. You can create a versioned"
echo "shared object using 'HAS_SOLIB_VERSION=1 make -f GNUmakefile-cross'"
echo "*******************************************************************************"
echo

[ "$0" = "$BASH_SOURCE" ] && exit 0 || return 0
