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

set(TENSORFLOW_CPU "cortex-m33+nodsp" CACHE STRING "Select Cortex-M processor")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")

string(REPLACE "+" ";" __CPU_FEATURES ${TENSORFLOW_CPU})
list(POP_FRONT __CPU_FEATURES CMAKE_SYSTEM_PROCESSOR)
string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} CMAKE_SYSTEM_PROCESSOR)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 11)

# CPU target
add_compile_options(-mcpu=${TENSORFLOW_CPU})
add_link_options(-mcpu=${TENSORFLOW_CPU} --specs=nosys.specs)

# Complation warnings
add_compile_options(
#    -Werror
    -Wsign-compare
    -Wdouble-promotion
    -Wshadow
    -Wunused-variable
    -Wmissing-field-initializers
    -Wunused-function
    -Wswitch
    -Wvla
    -Wall
    -Wextra
    -Wstrict-aliasing
    -Wno-unused-parameter)

# Configure compiler features
add_compile_options(
    -fno-unwind-tables
    -ffunction-sections
    -fdata-sections
    -fmessage-length=0
    "$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti;-fno-exceptions;-fno-threadsafe-statics>")
