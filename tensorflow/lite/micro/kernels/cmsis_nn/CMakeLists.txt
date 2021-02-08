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

option(TENSORFLOW_CMSIS_NN "Enable Arm CMSIS-NN" OFF)

if (NOT TENSORFLOW_CMSIS_NN)
    return()
endif()

# Build CMSIS-NN operators
target_compile_definitions(tensorflow-microlite PUBLIC CMSIS_NN)

target_include_directories(tensorflow-microlite PUBLIC
    ${TENSORFLOW_CMSIS_PATH}
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/DSP/Include
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/Core/Include
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Include)

target_sources(tensorflow-microlite PRIVATE
    add.cc
    conv.cc
    depthwise_conv.cc
    fully_connected.cc
    mul.cc
    pooling.cc
    softmax.cc
    svdf.cc)

# Build CMSIS-NN
# TODO Building CMSIS-NN should be part of CMSIS
add_library(cmsis-nn STATIC)

target_include_directories(cmsis-nn PRIVATE
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/DSP/Include
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/Core/Include
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Include)

target_sources(cmsis-nn PRIVATE
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/BasicMathFunctions/arm_elementwise_mul_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/BasicMathFunctions/arm_elementwise_add_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_q7_opt.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_q15_opt.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_mat_q7_vec_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/FullyConnectedFunctions/arm_fully_connected_mat_q7_vec_q15_opt.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SVDFunctions/arm_svdf_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConcatenationFunctions/arm_concatenation_s8_z.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConcatenationFunctions/arm_concatenation_s8_x.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConcatenationFunctions/arm_concatenation_s8_w.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConcatenationFunctions/arm_concatenation_s8_y.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_depthwise_conv_s8_core.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_conv_u8_basic_ver1.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_1x1_s8_fast.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_fast.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_q7_q15_reordered.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_q7_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_RGB.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_1x1_HWC_q7_fast_nonsquare.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_basic.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_separable_conv_HWC_q7_nonsquare.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_fast_nonsquare.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_conv_s8_opt.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_conv_3x3_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_s8_s16.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_basic.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q15_fast.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_fast_nonsquare.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_nn_mat_mult_kernel_s8_s16_reordered.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_separable_conv_HWC_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_conv_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_1_x_n_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_HWC_q7_basic_nonsquare.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_convolve_wrapper_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ConvolutionFunctions/arm_depthwise_conv_wrapper_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/PoolingFunctions/arm_pool_q7_HWC.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/PoolingFunctions/arm_avgpool_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/PoolingFunctions/arm_max_pool_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ActivationFunctions/arm_relu_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ActivationFunctions/arm_relu_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ActivationFunctions/arm_nn_activations_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ActivationFunctions/arm_relu6_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ActivationFunctions/arm_nn_activations_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_add_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_depthwise_conv_nt_t_padded_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_q7_to_q15_reordered_no_shift.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_depthwise_conv_nt_t_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nntables.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_accumulate_q7_to_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_mult_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_mult_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_q7_to_q15_reordered_with_offset.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_q7_to_q15_with_offset.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_mat_mul_core_4x_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_mat_mult_nt_t_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_vec_mat_mult_t_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_nn_mat_mul_core_1x_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/NNSupportFunctions/arm_q7_to_q15_no_shift.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SoftmaxFunctions/arm_softmax_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SoftmaxFunctions/arm_softmax_q15.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SoftmaxFunctions/arm_softmax_u8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SoftmaxFunctions/arm_softmax_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SoftmaxFunctions/arm_softmax_with_batch_q7.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/SVDFunctions/arm_svdf_s8.c
    ${TENSORFLOW_CMSIS_PATH}/CMSIS/NN/Source/ReshapeFunctions/arm_reshape_s8.c)

target_link_libraries(tensorflow-microlite PUBLIC cmsis-nn)
