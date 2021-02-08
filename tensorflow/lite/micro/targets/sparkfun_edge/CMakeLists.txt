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

include(../../cmake/helpers.cmake)

#############################################################################
# Toolchain setup
#############################################################################

if (NOT CMAKE_TOOLCHAIN_FILE)
    download_third_party(tensorflow-gcc-embedded
                         URL "http://mirror.tensorflow.org/developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2"
                         URL_MD5 299ebd3f1c2c90930d28ab82e5d8d6c0)

    set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/toolchain/arm-none-eabi-gcc.cmake)
endif()

#############################################################################
# Project
#############################################################################

cmake_minimum_required(VERSION 3.15.6)

project(tensorflow-sparkfun-edge VERSION 0.0.1)

include(CTest)

#############################################################################
# Tensorflow
#############################################################################

# Define target
set(TENSORFLOW_TARGET "sparkfun_edge")

# Override default Tensorflow microlite settings
option(TENSORFLOW_CMSIS_NN "Enable Arm CMSIS-NN" ON)

# Build Tensorflow microlite
add_subdirectory(../.. tensorflow-microlite)

#############################################################################
# Download thirdparty
#############################################################################

# AM SDK
download_third_party(tensorflow-am-sdk
                     URL "http://mirror.tensorflow.org/s3.asia.ambiqmicro.com/downloads/AmbiqSuite-Rel2.2.0.zip"
                     URL_MD5 7605fa2d4d97e6bb7a1190c92b66b597
                     PATCHES startup_gcc.c.patch hello_world.ld.patch)

# SF BSPS
download_third_party(tensorflow-sf-bsps
                     URL "http://mirror.tensorflow.org/github.com/sparkfun/SparkFun_Apollo3_AmbiqSuite_BSPs/archive/v0.0.7.zip"
                     URL_MD5 34199f7e754735661d1c8a70a40ca7a3)

FetchContent_GetProperties(tensorflow-cmsis)

#############################################################################
# Tensorflow sparkfun
#############################################################################

set(BOARD_BSP_PATH ${tensorflow-am-sdk_SOURCE_DIR}/boards/apollo3_evb/bsp)

add_library(tensorflow-sparkfun-edge STATIC)

target_include_directories(tensorflow-sparkfun-edge PUBLIC
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/Core/Include
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Include
    ${tensorflow-sf-bsps_SOURCE_DIR}/edge/bsp
    ${tensorflow-sf-bsps_SOURCE_DIR}/common/third_party/hm01b0
#    ${tensorflow-am-sdk_SOURCE_DIR}/boards/apollo3_evb/bsp
    ${tensorflow-am-sdk_SOURCE_DIR}/mcu/apollo3
    ${tensorflow-am-sdk_SOURCE_DIR}/mcu/apollo3/regs
    ${tensorflow-am-sdk_SOURCE_DIR}/mcu/apollo3/hal
    ${tensorflow-am-sdk_SOURCE_DIR}/CMSIS/AmbiqMicro/Include
    ${tensorflow-am-sdk_SOURCE_DIR}/devices
    ${tensorflow-am-sdk_SOURCE_DIR}/utils)

target_sources(tensorflow-sparkfun-edge PRIVATE
    ${tensorflow-am-sdk_SOURCE_DIR}/boards/apollo3_evb/examples/hello_world/gcc/startup_gcc.c
    ${tensorflow-am-sdk_SOURCE_DIR}/utils/am_util_delay.c
    ${tensorflow-am-sdk_SOURCE_DIR}/utils/am_util_faultisr.c
    ${tensorflow-am-sdk_SOURCE_DIR}/utils/am_util_id.c
    ${tensorflow-am-sdk_SOURCE_DIR}/utils/am_util_stdio.c
    ${tensorflow-am-sdk_SOURCE_DIR}/devices/am_devices_led.c)

target_sources(tensorflow-sparkfun-edge PRIVATE
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/BasicMathFunctions/arm_dot_prod_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/BasicMathFunctions/arm_mult_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/TransformFunctions/arm_rfft_init_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/TransformFunctions/arm_rfft_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/TransformFunctions/arm_bitreversal2.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/TransformFunctions/arm_cfft_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/TransformFunctions/arm_cfft_radix4_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/CommonTables/arm_const_structs.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/CommonTables/arm_common_tables.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/StatisticsFunctions/arm_mean_q15.c
    ${tensorflow-cmsis_SOURCE_DIR}/CMSIS/DSP/Source/StatisticsFunctions/arm_max_q7.c)

target_link_libraries(tensorflow-sparkfun-edge PUBLIC
    ${BOARD_BSP_PATH}/gcc/bin/libam_bsp.a
    ${tensorflow-am-sdk_SOURCE_DIR}/mcu/apollo3/hal/gcc/bin/libam_hal.a
    m stdc++ c nosys gcc)

if (EXISTS "${tensorflow-gcc-embedded_SOURCE_DIR}/lib/gcc/arm-none-eabi/7.3.1/thumb/v7e-m/fpv4-sp/hard/crtbegin.o")
    target_link_libraries(tensorflow-sparkfun-edge PUBLIC
        "${tensorflow-gcc-embedded_SOURCE_DIR}/lib/gcc/arm-none-eabi/7.3.1/thumb/v7e-m/fpv4-sp/hard/crtbegin.o")
endif()

target_link_options(tensorflow-sparkfun-edge PUBLIC
    -nostdlib
    --entry Reset_Handler
    -T${tensorflow-am-sdk_SOURCE_DIR}/boards/apollo3_evb/examples/hello_world/gcc/hello_world.ld)

#############################################################################
# Tensorflow tests
#############################################################################

target_link_libraries(tensorflow-tests INTERFACE
    tensorflow-sparkfun-edge)

#############################################################################
# Tensorflow microlite
#############################################################################

target_compile_definitions(tensorflow-microlite PUBLIC
    __FPU_PRESENT=1 # Remove
    NDEBUG          # Remove
    PART_apollo3
    AM_PACKAGE_BGA
    AM_PART_APOLLO3
    ARM_MATH_CM4
    GEMMLOWP_ALLOW_SLOW_SCALAR_FALLBACK
    TF_LITE_MCU_DEBUG_LOG)
