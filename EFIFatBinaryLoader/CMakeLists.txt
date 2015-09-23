set(PRODUCT_NAME EFIFatBinary)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

include_directories("${HOPPER_SDK_PATH}")

add_library(
    ${PRODUCT_NAME} MODULE
    EFIFatBinaryLoader.mm
)
set_target_properties(
    ${PRODUCT_NAME} PROPERTIES
    BUNDLE TRUE
    BUNDLE_EXTENSION hopperLoader
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Info.plist.in
)
target_link_libraries(${PRODUCT_NAME} "-framework Foundation")
