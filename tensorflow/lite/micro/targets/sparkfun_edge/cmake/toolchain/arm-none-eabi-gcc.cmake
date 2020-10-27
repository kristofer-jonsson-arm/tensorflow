#
# Copyright 2021 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include(FetchContent)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR "cortex-m4")
set(CMAKE_C_COMPILER "${tensorflow-gcc-embedded_SOURCE_DIR}/bin/arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "${tensorflow-gcc-embedded_SOURCE_DIR}/bin/arm-none-eabi-g++")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

# CPU target
add_compile_options(
    -mcpu=${CMAKE_SYSTEM_PROCESSOR}
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard

    -ggdb
    -nostdlib

    -fno-unwind-tables
    -ffunction-sections
    -fdata-sections
    -fmessage-length=0
    -fno-delete-null-pointer-checks
    -fomit-frame-pointer
    -funsigned-char
    "$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti;-fno-exceptions;-fno-threadsafe-statics;-fno-use-cxa-atexit>"
)

add_link_options(
    -mcpu=${CMAKE_SYSTEM_PROCESSOR}
    -mthumb
    -mfpu=fpv4-sp-d16
    -mfloat-abi=hard

    -nostartfiles
    -static
    -nostdlib
    --specs=nano.specs
)

# Complation warnings
add_compile_options(
    -Wall
    -Wextra
#    -Werror
    -Wsign-compare
    -Wdouble-promotion
    -Wmissing-field-initializers  # Remove
    -Wshadow
    -Wswitch
    -Wvla
    -Wstrict-aliasing
    -Wunused-variable
    -Wunused-function
    -Wno-missing-field-initializers
    -Wno-strict-aliasing
    -Wno-type-limits
    -Wno-unused-function
    -Wno-unused-parameter)

# Remove
add_compile_options(
    -O3
    -MMD)
