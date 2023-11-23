cmake_minimum_required(VERSION 3.10)
project(the-language)

find_package(LLVM REQUIRED CONFIG)

add_definitions(${LLVM_DEFINITIONS})
link_directories(${LLVM_LIBRARY_DIRS})

# Find Flex and Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# Set up source files
set(SOURCE_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.cpp
    src/ast.cpp
    src/main.cpp
)

# Set include directories
set(INCLUDE_DIRS
    ${LLVM_INCLUDE_DIRS}
    ${CMAKE_CURRENT_BINARY_DIR}
    src/
)

# Flex and Bison targets
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.cpp COMPILE_FLAGS "-Wcounterexamples")
FLEX_TARGET(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.cpp)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Add the include directories
include_directories(${INCLUDE_DIRS})

# Executable
add_executable(the-language ${BISON_Parser_OUTPUTS} ${FLEX_Lexer_OUTPUTS} ${SOURCE_FILES})

# Link against necessary libraries if needed
target_link_libraries(the-language m)
