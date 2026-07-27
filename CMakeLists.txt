cmake_minimum_required(VERSION 3.25)

project(
    embedded_full_cycle_course
    VERSION 0.1.0
    LANGUAGES C
)

add_subdirectory(firmware/common)

if(CMAKE_CROSSCOMPILING)
    enable_language(ASM)
    add_subdirectory(firmware/target)
else()
    include(CTest)

    if(BUILD_TESTING)
        add_subdirectory(tests/host)
    endif()
endif()