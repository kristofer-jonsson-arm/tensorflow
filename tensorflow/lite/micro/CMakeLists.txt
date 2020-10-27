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

cmake_minimum_required(VERSION 3.15.6)

# Set default compile options if no toolchain file has been provided
if (NOT CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain/default.cmake)
endif()

project(tensorflow-microlite VERSION 0.0.1)

include(CTest)
include(cmake/helpers.cmake)

#############################################################################
# Helper functions
#############################################################################

set(TENSORFLOW_TEST_COMMAND "" CACHE STRING "Command used to run unit tests")

# Build a test from source
function(tensorflow_add_test target)
    if(NOT BUILD_TESTING)
        return()
    endif()

    cmake_parse_arguments(ARGS "" "" "SOURCES;LIBRARIES" ${ARGN})

    add_executable(${target})
    target_sources(${target} PRIVATE ${ARGS_SOURCES})
    target_link_libraries(${target} PRIVATE tensorflow-tests ${ARGS_LIBRARIES})

    add_test(NAME tensorflow_${target}
             COMMAND ${TENSORFLOW_TEST_COMMAND} $<TARGET_FILE:${target}>)
endfunction()

function(tensorflow_add_tests)
    foreach(source IN LISTS ARGN)
        get_filename_component(target ${source} NAME_WLE)
        tensorflow_add_test(${target} SOURCES ${source})
    endforeach()
endfunction()

#############################################################################
# Add targets
#############################################################################

# Tensorflow microlite library
add_library(tensorflow-microlite STATIC)

# All unit tests link against this interface library. This library can be
# used to add compile and link options that affect all unit test binaries
add_library(tensorflow-tests INTERFACE)

#############################################################################
# Download thirdparty
#############################################################################

# Flatbuffers
download_third_party(tensorflow-flatbuffers
    URL "http://mirror.tensorflow.org/github.com/google/flatbuffers/archive/dca12522a9f9e37f126ab925fd385c807ab4f84e.tar.gz"
    URL_MD5 dfa0ac3073b78ddacdcacf8ca189be91)

target_include_directories(tensorflow-microlite PUBLIC
    ${tensorflow-flatbuffers_SOURCE_DIR}/include)

# Gemlowp
download_third_party(tensorflow-gemlowp
    URL "https://github.com/google/gemmlowp/archive/719139ce755a0f31cbf1c37f7f98adcc7fc9f425.zip"
    URL_MD5 7e8191b24853d75de2af87622ad293ba)

target_include_directories(tensorflow-microlite PUBLIC
    ${tensorflow-gemlowp_SOURCE_DIR})

# Ruy
download_third_party(tensorflow-ruy
    URL "https://github.com/google/ruy/archive/5bb02fbf90824c2eb6cd7418f766c593106a332b.zip"
    URL_MD5 c720b1743360259ac45809a321f8f26c)

target_include_directories(tensorflow-microlite PUBLIC
    ${tensorflow-ruy_SOURCE_DIR})

# CMSIS
download_third_party(tensorflow-cmsis
    URL "http://github.com/ARM-software/CMSIS_5/archive/01f5b32badf7b78c85a24a7149b56400fa6a2999.zip"
    URL_MD5 823916c6f1749c65fd0bfdeec20b30ed)

set(TENSORFLOW_CMSIS_PATH "${tensorflow-cmsis_SOURCE_DIR}" CACHE PATH "Path to CMSIS")

# Ethos-U
download_third_party(tensorflow-ethos-u
    URL "https://git.mlplatform.org/ml/ethos-u/ethos-u-core-driver.git/snapshot/ethos-u-core-driver-2b201c340788ac582cec160b7217c2b5405b04f9.tar.gz"
    URL_MD5 0c148b90a1ee01de398892eb3a63e717)

set(TENSORFLOW_ETHOS_U_PATH "${tensorflow-ethos-u_SOURCE_DIR}" CACHE PATH "Path to Ethos-U")

#############################################################################
# Tensorflow
#############################################################################

# Microlite lib
target_include_directories(tensorflow-microlite PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/../../..)

target_compile_definitions(tensorflow-microlite PUBLIC
    TF_LITE_STATIC_MEMORY
    TF_LITE_DISABLE_X86_NEON)

target_sources(tensorflow-microlite PRIVATE
    all_ops_resolver.cc
    debug_log.cc
    memory_helpers.cc
    micro_allocator.cc
    micro_error_reporter.cc
    micro_interpreter.cc
    micro_profiler.cc
    micro_string.cc
    micro_time.cc
    micro_utils.cc
    recording_micro_allocator.cc
    recording_simple_memory_allocator.cc
    simple_memory_allocator.cc
    test_helpers.cc)

target_sources(tensorflow-microlite PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../c/common.c
    ${CMAKE_CURRENT_SOURCE_DIR}/../core/api/error_reporter.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../core/api/flatbuffer_conversions.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../core/api/op_resolver.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../core/api/tensor_utils.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../kernels/internal/quantization_util.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../kernels/kernel_util.cc
    ${CMAKE_CURRENT_SOURCE_DIR}/../schema/schema_utils.cc)

target_link_libraries(tensorflow-tests INTERFACE
    tensorflow-microlite)

tensorflow_add_tests(
    memory_arena_threshold_test.cc
    memory_helpers_test.cc
    micro_allocator_test.cc
    micro_error_reporter_test.cc
    micro_interpreter_test.cc
    micro_mutable_op_resolver_test.cc
    micro_string_test.cc
    micro_time_test.cc
    micro_utils_test.cc
    recording_micro_allocator_test.cc
    recording_simple_memory_allocator_test.cc
    simple_memory_allocator_test.cc
    testing_helpers_test.cc)

add_subdirectory(kernels)
add_subdirectory(cortex_m_generic)
add_subdirectory(memory_planner)
add_subdirectory(benchmarks)
add_subdirectory(testing)
add_subdirectory(examples)
