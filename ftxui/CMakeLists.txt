cmake_minimum_required(VERSION 3.14)
project(ftxui VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# --- DEPENDENCIES (FTXUI) ---
include(FetchContent)
FetchContent_Declare(ftxui
  GIT_REPOSITORY https://github.com/ArthurSonzogni/FTXUI
  GIT_TAG v5.0.0
)
FetchContent_MakeAvailable(ftxui)

# --- APP EXECUTABLE ---
add_executable(ftxui_app src/teste.cpp) 

target_link_libraries(ftxui_app PRIVATE 
    ftxui::screen
    ftxui::dom
    ftxui::component
)