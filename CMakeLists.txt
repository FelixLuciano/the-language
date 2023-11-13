cmake_minimum_required(VERSION 3.10)
project(the-language)

# Find Flex and Bison
find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

set(SOURCE_FILES
    ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.c
    src/parser.y
    src/lexer.l
    src/main.c
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lfl")

# Flex and Bison targets
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c COMPILE_FLAGS "--defines=${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h -Wcounterexamples")
FLEX_TARGET(Lexer src/lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.yy.c)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Executable
add_executable(the-language ${BISON_Parser_OUTPUTS} ${FLEX_Lexer_OUTPUTS} ${SOURCE_FILES})

# Link against necessary libraries if needed
target_link_libraries(the-language m)
