cmake_minimum_required(VERSION 3.14)
project(cli LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(simple simple.cpp)
add_executable(subcommands subcommands.cpp)

target_include_directories(simple PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(subcommands PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include)