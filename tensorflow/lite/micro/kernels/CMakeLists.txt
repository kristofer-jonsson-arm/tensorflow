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

add_subdirectory(cmsis_nn)
add_subdirectory(ethos_u)

target_sources(tensorflow-microlite PRIVATE
    activations.cc
    add.cc
    arg_min_max.cc
    batch_to_space_nd.cc
    cast.cc
    ceil.cc
    circular_buffer.cc
    comparisons.cc
    concatenation.cc
    conv.cc
    conv_test_common.cc
    depthwise_conv.cc
    dequantize.cc
    detection_postprocess.cc
    elementwise.cc
    ethosu.cc
    exp.cc
    flexbuffers_generated_data.cc
    floor.cc
    fully_connected.cc
    fully_connected_common.cc
    hard_swish.cc
    kernel_runner.cc
    kernel_util.cc
    l2norm.cc
    logical.cc
    logistic.cc
    maximum_minimum.cc
    mul.cc
    neg.cc
    pack.cc
    pad.cc
    pooling.cc
    prelu.cc
    quantize.cc
    quantize_common.cc
    reduce.cc
    reshape.cc
    resize_nearest_neighbor.cc
    round.cc
    shape.cc
    softmax.cc
    softmax_common.cc
    space_to_batch_nd.cc
    split.cc
    split_v.cc
    strided_slice.cc
    sub.cc
    svdf.cc
    svdf_common.cc
    tanh.cc
    transpose_conv.cc
    unpack.cc
    zeros_like.cc)

tensorflow_add_tests(
    activations_test.cc
    add_test.cc
    arg_min_max_test.cc
    batch_to_space_nd_test.cc
    cast_test.cc
    ceil_test.cc
    circular_buffer_test.cc
    comparisons_test.cc
    concatenation_test.cc
    conv_test.cc
    depthwise_conv_test.cc
    dequantize_test.cc
    detection_postprocess_test.cc
    elementwise_test.cc
    exp_test.cc
    floor_test.cc
    fully_connected_test.cc
    hard_swish_test.cc
    l2norm_test.cc
    logical_test.cc
    logistic_test.cc
    maximum_minimum_test.cc
    mul_test.cc
    neg_test.cc
    pack_test.cc
    pad_test.cc
    pooling_test.cc
    prelu_test.cc
    quantization_util_test.cc
    quantize_test.cc
    reduce_test.cc
    reshape_test.cc
    resize_nearest_neighbor_test.cc
    round_test.cc
    shape_test.cc
    softmax_test.cc
    space_to_batch_nd_test.cc
    split_test.cc
    split_v_test.cc
    strided_slice_test.cc
    sub_test.cc
    svdf_test.cc
    tanh_test.cc
    transpose_conv_test.cc
    unpack_test.cc
    zeros_like_test.cc)
