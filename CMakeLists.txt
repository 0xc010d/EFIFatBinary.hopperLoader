cmake_minimum_required(VERSION 3.0)

project(EFIFatBinaryLoader)

set(HOPPER_SDK_PATH ${CMAKE_SOURCE_DIR}/HopperSDK/include)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

add_subdirectory(EFIFatBinaryLoader)
add_subdirectory(HopperPatch)
