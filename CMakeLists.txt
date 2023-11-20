cmake_minimum_required(VERSION 3.10)
project(the-language)

# Find Flex and Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

# Set up source files
set(SOURCE_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.c
    src/ast.c
    src/main.c
)

# Set include directories
set(INCLUDE_DIRS
    src/
)

# Flex and Bison targets
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c COMPILE_FLAGS "-Wcounterexamples")
FLEX_TARGET(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.c)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Add the include directories
include_directories(${INCLUDE_DIRS})

# Executable
add_executable(the-language ${BISON_Parser_OUTPUTS} ${FLEX_Lexer_OUTPUTS} ${SOURCE_FILES})

# Link against necessary libraries if needed
target_link_libraries(the-language m)
