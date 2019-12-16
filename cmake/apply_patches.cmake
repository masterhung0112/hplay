function(apply_patches)
    cmake_parse_arguments(_ap "QUIET" "SOURCE_PATH" "PATCHES" ${ARGN})

    find_program(GIT NAMES git git.cmd)
    set(PATCHNUM 0)
    foreach(PATCH ${_ap_PATCHES})
        get_filename_component(ABSOLUTE_PATCH "${PATCH}" ABSOLUTE BASE_DIR "${CURRENT_PORT_DIR}")
        message(STATUS "Applying patch ${PATCH}")
        set(LOGNAME patch-${TARGET_TRIPLET}-${PATCHNUM})
        execute_process(
            COMMAND ${GIT} --work-tree=. --git-dir=.git apply "${ABSOLUTE_PATCH}" --ignore-whitespace --whitespace=nowarn --verbose
            OUTPUT_FILE ${CURRENT_BUILDTREES_DIR}/${LOGNAME}-out.log
            ERROR_FILE ${CURRENT_BUILDTREES_DIR}/${LOGNAME}-err.log
            WORKING_DIRECTORY ${_ap_SOURCE_PATH}
            RESULT_VARIABLE error_code
        )

        if(error_code AND NOT _ap_QUIET)
            message(STATUS "Applying patch failed. This is expected if this patch was previously applied.")
        endif()

        math(EXPR PATCHNUM "${PATCHNUM}+1")
    endforeach()
endfunction()