cmake_minimum_required(VERSION 3.0)

set(PRODUCT_NAME EFIFatBinary)
project(${PRODUCT_NAME})

set(HOPPER_SDK_PATH ${CMAKE_SOURCE_DIR}/HopperSDK/include)
set(HOPPER_PLUGINS_PATH "~/Library/Application Support/Hopper/Plugins")
set(HOPPER_PLUGIN_LOADER_DIRNAME Loaders)
set(HOPPER_PLUGIN_LOADER_EXTENSION hopperLoader)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_INSTALL_PREFIX ${HOPPER_PLUGINS_PATH} CACHE PATH "Plugins install prefix" FORCE)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories("${HOPPER_SDK_PATH}")

add_library(
    ${PRODUCT_NAME} MODULE
    EFIFatBinaryLoader.mm
)
set_target_properties(
    ${PRODUCT_NAME} PROPERTIES
    BUNDLE TRUE
    BUNDLE_EXTENSION ${HOPPER_PLUGIN_LOADER_EXTENSION}
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in
)
target_link_libraries(${PRODUCT_NAME} "-framework Foundation")

install(
    TARGETS ${PRODUCT_NAME}
    LIBRARY DESTINATION ${HOPPER_PLUGIN_LOADER_DIRNAME}
)
