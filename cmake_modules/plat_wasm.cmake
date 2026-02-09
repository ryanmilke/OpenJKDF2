macro(plat_initialize)
    message( STATUS "Targeting Emscripten WASM" )

    set(BIN_NAME "openjkdf2")

    add_definitions(-DARCH_WASM)

    include(cmake_modules/plat_feat_full_sdl2.cmake)
    set(TARGET_USE_PHYSFS FALSE)
    set(OPENJKDF2_NO_ASAN TRUE)
    set(TARGET_CAN_JKGM FALSE)
    set(TARGET_USE_CURL FALSE)
    set(TARGET_BUILD_TESTS FALSE)
    set(TARGET_FIND_OPENAL FALSE)
    set(TARGET_USE_GAMENETWORKINGSOCKETS FALSE)
    set(SDL2_COMMON_LIBS "")

    set(TARGET_WASM TRUE)

    add_link_options(-fno-exceptions)
    add_compile_options(-fno-exceptions)
    string(CONCAT USE_GLOBAL_FLAGS
        "-sUSE_SDL=2 "
        "-sUSE_SDL_MIXER=2 "
    )
    string(CONCAT USE_LINKER_FLAGS
        "${USE_GLOBAL_FLAGS} "
        "-sWASM=1 "
        "-sENVIRONMENT='web' "
        "-sMODULARIZE=1 "
        "-sEXPORT_ES6=1 "
        "-sEXPORT_NAME='OpenJKDF2' "
        "-sINVOKE_RUN=0 "
        "-sEXPORTED_FUNCTIONS=\"['_main','_neon_canvas_resize']\" "
        "-sEXPORTED_RUNTIME_METHODS=\"['abort','ccall','cwrap','FS','callMain']\" "
        "-sALLOW_MEMORY_GROWTH=1 "
        "-sFULL_ES2 "
        "-sFULL_ES3 "
        "-sUSE_WEBGL2=1 "
        "-sASYNCIFY "
        "-sINITIAL_MEMORY=256mb "
        "-sSTACK_SIZE=128mb"
    )
    string(CONCAT USE_COMP_FLAGS
        "${USE_GLOBAL_FLAGS} "
    )
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${USE_COMP_FLAGS}")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${USE_COMP_FLAGS}")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${USE_LINKER_FLAGS} --profiling -s FORCE_FILESYSTEM=1 ")
    set(CMAKE_EXECUTABLE_SUFFIX .js)

    add_compile_options(-O3 -Wuninitialized -Wall -Wno-unused-variable -Wno-parentheses -Wno-missing-braces)
endmacro()

macro(plat_specific_deps)
    set(SDL2_COMMON_LIBS "")
endmacro()

macro(plat_link_and_package)
    target_link_libraries(${BIN_NAME} PRIVATE -lm -lSDL2 -lSDL2_mixer -lGL -lGLEW -lopenal)
    target_link_libraries(sith_engine PRIVATE nlohmann_json::nlohmann_json)

    add_custom_command(TARGET ${BIN_NAME}
        POST_BUILD
        COMMAND $ENV{EMSCRIPTEN_ROOT}/tools/file_packager ${CMAKE_CURRENT_BINARY_DIR}/openjkdf2_data.data --preload ${PROJECT_SOURCE_DIR}/wasm_out@/ --js-output=${CMAKE_CURRENT_BINARY_DIR}/openjkdf2_data.js 
        )
endmacro()