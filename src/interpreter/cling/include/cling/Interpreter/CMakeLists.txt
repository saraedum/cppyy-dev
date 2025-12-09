include_directories(${LLVM_INCLUDE_DIRS})

set(LLVM_TARGET_DEFINITIONS ClingOptions.td)
if (CAN_RUN_BUILT_BINARIES)
    # Use the native llvm-tblgen to create ClingOptions.inc
    tablegen(LLVM ClingOptions.inc -gen-opt-parser-defs)
    add_public_tablegen_target(ClingDriverOptions)
else()
    # Use a pre-rendered ClingOptions.inc since we cannot invoke the host's llvm-tblgen
    set(STATIC_CLING_OPTIONS_INC "" CACHE PATH "Path to llvm-tblgen generated ClingOptions.inc")

    if("${STATIC_CLING_OPTIONS_INC}" STREQUAL "")
      message(FATAL_ERROR "When cross-compiling, ClingOptions.inc cannot be created and must be provided with -DSTATIC_CLING_OPTIONS_INC to cmake")
    endif()

    add_custom_command(OUTPUT ClingOptions.inc
                       COMMAND ${CMAKE_COMMAND} -E copy
                       ${STATIC_CLING_OPTIONS_INC}
                       ClingOptions.inc
                       COMMENT "Copying prebuilt user-provided ${STATIC_CLING_OPTIONS_INC} to ClingOptions.inc"
    )

    add_custom_target(ClingDriverOptions DEPENDS ClingOptions.inc)
endif()