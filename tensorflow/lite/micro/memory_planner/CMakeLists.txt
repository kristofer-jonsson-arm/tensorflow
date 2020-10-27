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

set(NAMES emerg alert crit err warning notice info debug)
set(TENSORFLOW_MEMORY_PLANNER "greedy" CACHE STRING "Driver log severity level ${NAMES}")
set_property(CACHE TENSORFLOW_MEMORY_PLANNER PROPERTY STRINGS ${NAMES})

if (${TENSORFLOW_MEMORY_PLANNER} STREQUAL "greedy")
    target_sources(tensorflow-microlite PRIVATE
        greedy_memory_planner.cc)
    tensorflow_add_tests(
        greedy_memory_planner_test.cc)
else()
    target_sources(tensorflow-microlite PRIVATE
        linear_memory_planner.cc)
    tensorflow_add_tests(
        linear_memory_planner_test.cc)
endif()
