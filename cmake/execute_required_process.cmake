function(execute_required_process)
	cmake_parse_arguments(execute_required_process "" "WORKING_DIRECTORY;LOGNAME" "COMMAND" ${ARGN})
	set(LOG_OUT "${CURRENT_BUILDTREES_DIR}/${execute_required_process_LOGNAME}-out.log")
    set(LOG_ERR "${CURRENT_BUILDTREES_DIR}/${execute_required_process_LOGNAME}-err.log")
	execute_process(
        COMMAND ${execute_required_process_COMMAND}
        OUTPUT_FILE ${LOG_OUT}
        ERROR_FILE ${LOG_ERR}
        RESULT_VARIABLE error_code
        WORKING_DIRECTORY ${execute_required_process_WORKING_DIRECTORY})
	if(error_code)
		set(LOGS)
        file(READ "${LOG_OUT}" out_contents)
        file(READ "${LOG_ERR}" err_contents)
        if(out_contents)
            list(APPEND LOGS "${LOG_OUT}")
        endif()
        if(err_contents)
            list(APPEND LOGS "${LOG_ERR}")
        endif()
        set(STRINGIFIED_LOGS)
        foreach(LOG ${LOGS})
            file(TO_NATIVE_PATH "${LOG}" NATIVE_LOG)
            list(APPEND STRINGIFIED_LOGS "    ${NATIVE_LOG}\n")
        endforeach()
		message(FATAL_ERROR
            "  Command failed: ${execute_required_process_COMMAND}\n"
            "  Working Directory: ${execute_required_process_WORKING_DIRECTORY}\n"
            "  Error code: ${error_code}\n"
            "  See logs for more information:\n"
            ${STRINGIFIED_LOGS}
        )
	endif(error_code)
endfunction()