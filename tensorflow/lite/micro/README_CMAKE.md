# CMake

CMake is a cross-platform tool that is used to generate build files for a range
of different build tools. The process can be divided into.

1. Configuration with CMake.
2. Building with the selected generator.
3. Running tests with `ctest`.
4. Packaging.

## Configuration

To keep the similarities to the existing makefile build system, all examples
below assume we are calling `cmake` from the Tensorflow root folder.

### Default configuration

CMake is designed to generate build files *out of tree*.

```
$ cmake -B build tensorflow/lite/micro
```

Configuration file are found in the `build` folder.

### Enabling options

Build options can be listed with `cmake -LH` and are set on the command line prefixed by `-D`.

```
$ cmake -B build tensorflow/lite/micro -DTENSORFLOW_CMSIS_NN=ON
```

### Cross compiling

Cross compiling is preferably setup in an external toolchain file. There are
toolchain files provided for reference under
`tensorflow/lite/micro/cmake/toolchain`, but there is nothing preventing a user
from defining a custom toolchain file.

```
$ cmake -B build tensorflow/lite/micro -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain/arm-none-eabi-gcc.cmake -DTENSORFLOW_CPU=cortex-m4
```

## Building

This section assumes we have changed to the `build` directory and that `make`
was used as generator in the configuration step.

```
$ make
```

### Building individual targets

The build targets CMake has created can be listed with `make help` and can be build separatelly.

```
$ make tensorflow-microlite
```

## Testing

Running tests is done by `ctest`.

```
$ ctest
```

The available tests can be listed with `ctest -N` and run individually with `ctest -R <regular expression>`.

```
$ ctest -R person-detection
```

### Running cross compiled tests

Running cross compiled tests will required either a physical target or an emulator.

# Examples

This section lists a few example how to build with the existing build system,
comparing that with the equivalent CMake commands.

All examles assume we begin at the root of the Tensorflow repo.

## Building and testing conv_test only

Building and testing the *conv_test* only looks like this with the existing
build system.

```
$ make -f tensorflow/lite/micro/tools/make/Makefile test_kernel_conv_test
```

`cmake` is run without any special arguments. However `make` and `ctest` are
passed extra arguments to limit the build process and the test scope.

1. Change to Tensorflow root folder.
2. Remove build folder.
   ```
   $ rm -rf build
   ```
3. Configure
   ```
   $ cmake -B build tensorflow/lite/micro
   ```
4. Build (native)
   ```
   $ cd build
   $ make conv_test
   ```
5. Test
   ```
   $ ctest -V -R tensorflow_conv_test
   ```

## Cross compiling microlite

In the exampe below the microlite library is cross compiled for Arm Cortex-M4
with CMSIS-NN enabled. Equivalent to this command in the original make based
build system.

```
$ make -f tensorflow/lite/micro/tools/make/Makefile TAGS=cmsis-nn TARGET=cortex_m_generic TARGET_ARCH=cortex-m4+fp microlite
```

Cross compiling in CMake requires a toolchain file. For this particular example
​we are using a toolchain file that has been provided as an example. This
toolchain takes `TENSORFLOW_CPU` as input allowing the user to select which CPU
to compile for.

1. Change to Tensorflow root folder.
2. Remove build folder.
   ```
   $ rm -rf build
   ```
3. Configure
   ```
   $ cmake -B build tensorflow/lite/micro -DCMAKE_TOOLCHAIN_FILE=$PWD/tensorflow/lite/micro/cmake/toolchain/armclang.cmake -DTENSORFLOW_CPU=cortex-m4 -DTENSORFLOW_CMSIS_NN=ON
   ```
4. Build
   ```
   $ cd build
   $ make tensorflow-microlite
   ```

## Building person detection binary for Sparkfun

Building the SparkFun Edge target is split into a configuration step with
`cmake` and a build step with `make`. This is equivalent to the following
command in the existing make build system:

```
$ make -f tensorflow/lite/micro/tools/make/Makefile TARGET=sparkfun_edge person_detection_int8_bin
```

1. Change to Tensorflow root folder.
2. Remove build folder.
   ```
   $ rm -rf build
   ```
3. Configure.
   ```
   $ cmake -B build tensorflow/lite/micro/targets/sparkfun_edge
   ```
4. Build person detection binary
   ```
   $ cd build
   $ make person-detection
   ```

Find the binary here `build/tensorflow-microlite/examples/person_detection/`.

## Verbose build and testing

CMake and CTest will by default limit the information printed to the console.
Verbose builds and extra debug information can be enabled by passing extra
arguments to `make` and `ctest`.

```
$ make VERBOSE=1
$ ctest -V
```

## Clean build

The build directory can be cleaned without having to rerun CMake.

```
$ make clean
```

CMake places all downloads and build artifacts out of tree. Removing the build
directory is the safest way to produce a clean build.

```
$ rm -rf build
```
