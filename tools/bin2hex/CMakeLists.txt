cmake_minimum_required(VERSION 2.8)
project (cqt_tyolo)
enable_language(C)

add_definitions("-pg -Wall -g -Iinc")
include_directories(inc)
SET(CMAKE_EXE_LINKER_FLAGS  "-pg")

add_executable(hex2bin
        hex2bin.c)

target_link_libraries(hex2bin m)
