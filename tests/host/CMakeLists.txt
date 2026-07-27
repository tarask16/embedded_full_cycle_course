add_executable(
    efc_core_tests
    test_checksum.c
)

target_link_libraries(
    efc_core_tests
    PRIVATE
        efc_core
)

target_compile_features(
    efc_core_tests
    PRIVATE
        c_std_11
)

if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(
        efc_core_tests
        PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wsign-conversion
    )
endif()

add_test(
    NAME efc_core.checksum
    COMMAND efc_core_tests
)