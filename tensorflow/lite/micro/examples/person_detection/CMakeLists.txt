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

# Flatbuffers
download_third_party(tensorflow-person-detection-model
                     URL "https://storage.googleapis.com/download.tensorflow.org/data/tf_lite_micro_person_data_int8_grayscale_2020_12_1.zip"
                     URL_MD5 e765cc76889db8640cfe876a37e4ec00)

add_library(person-detection-model INTERFACE)

# Person detection model
target_sources(person-detection-model INTERFACE
    model_settings.cc
    ${tensorflow-person-detection-model_SOURCE_DIR}/person_detect_model_data.cc)

# Person detection test
tensorflow_add_test(person-detection-test
                    SOURCES
                        person_detection_test.cc
                        ${tensorflow-person-detection-model_SOURCE_DIR}/no_person_image_data.cc
                        ${tensorflow-person-detection-model_SOURCE_DIR}/person_image_data.cc
                    LIBRARIES person-detection-model)

# Image provider test
tensorflow_add_test(person-detection-image-provider
                    SOURCES
                        image_provider_test.cc
                        image_provider.cc
                    LIBRARIES person-detection-model)

# Detection responder test
tensorflow_add_test(person-detection-responder
                    SOURCES
                        detection_responder_test.cc
                        detection_responder.cc
                    LIBRARIES person-detection-model)

# Person detection
tensorflow_add_test(person-detection
    SOURCES
        main.cc
        main_functions.cc
    LIBRARIES person-detection-model)

if (TENSORFLOW_TARGET STREQUAL "sparkfun_edge")
    target_sources(person-detection PRIVATE
        himax_driver/HM01B0.c
        himax_driver/HM01B0_debug.c
        himax_driver/HM01B0_optimized.c
        sparkfun_edge/detection_responder.cc
        sparkfun_edge/image_provider.cc)
else()
    target_sources(person-detection PRIVATE
        detection_responder.cc
        image_provider.cc)
    set_tests_properties(tensorflow_person-detection PROPERTIES
        DISABLED TRUE)
endif()
