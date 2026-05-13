cmake_minimum_required(VERSION 3.27)

project(ocm_tester VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -Wall -Wextra -Werror")

add_executable(transfer_benchmark)

target_include_directories(transfer_benchmark PRIVATE
    include
)

target_sources(transfer_benchmark PRIVATE
    src/transfer_benchmark.cpp
)