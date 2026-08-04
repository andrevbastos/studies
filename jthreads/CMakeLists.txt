cmake_minimum_required(VERSION 3.14)
project(threads VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(include)

set(SOURCES 
    src/main.cpp 
)

add_executable(threads ${SOURCES})