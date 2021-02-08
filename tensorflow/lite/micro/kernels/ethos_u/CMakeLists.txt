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

option(TENSORFLOW_ETHOS_U "Enable Arm Ethos-U NPU" OFF)

if (NOT TENSORFLOW_ETHOS_U)
    return()
endif()

# Build glue layer
target_sources(tensorflow-microlite PRIVATE ethosu.cc)
target_compile_definitions(tensorflow-microlite PUBLIC ETHOSU)

# Build Ethos-U driver
set(CMSIS_PATH "${TENSORFLOW_CMSIS_PATH}" CACHE PATH "Path to CMSIS.")
add_subdirectory(${TENSORFLOW_ETHOS_U_PATH} ethos-u)
target_link_libraries(tensorflow-microlite PUBLIC ethosu_core_driver)
