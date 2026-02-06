cmake_minimum_required(VERSION 3.14)
project(json VERSION 0.1.0 LANGUAGES CXX)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- DEPENDENCIES (FTXUI) ---
include(FetchContent)
FetchContent_Declare(
  nlohmann_json
  GIT_REPOSITORY https://github.com/nlohmann/json.git
  GIT_TAG v3.11.3
)
FetchContent_MakeAvailable(nlohmann_json)

# --- APP EXECUTABLE ---
add_executable(json_app src/main.cpp) 

target_link_libraries(json_app PRIVATE
  nlohmann_json::nlohmann_json
)