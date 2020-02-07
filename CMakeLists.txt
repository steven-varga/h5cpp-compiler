#  _____________________________________________________________________________
#  Copyright (c) <2018-2020> <copyright Steven Varga, Toronto, On>
#  Contact: Steven Varga
#           steven@vargaconsulting.ca
#           2018-2020 Toronto, On Canada
#  _____________________________________________________________________________

cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(h5cpp-compiler-dev VERSION 1.10.4.5 LANGUAGES CXX C)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(LLVM 6.0.0 REQUIRED CONFIG)


message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})
link_directories(${LLVM_LIBRARY_DIRS})
add_executable(h5cpp src/h5cpp.cpp)

target_link_libraries(h5cpp
  LLVM
  clangFrontend
  clangSerialization
  clangDriver
  clangParse
  clangSema
  clangAnalysis
  clangRewrite
  clangRewriteFrontend
  clangASTMatchers
  clangAST
  clangBasic
  clangEdit
  clangLex
  clangTooling
)

