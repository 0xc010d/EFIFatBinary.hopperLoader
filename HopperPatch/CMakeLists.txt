set(PRODUCT_NAME HopperPatch)

set(CMAKE_SKIP_RPATH TRUE)

add_library(
    ${PRODUCT_NAME} SHARED
    HopperPatch.m
)
target_link_libraries(${PRODUCT_NAME} "-framework Foundation")
