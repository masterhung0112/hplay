function(download_distfile VAR)
	set(options SKIP_SHA512)
    set(oneValueArgs FILENAME SHA512)
    set(multipleValuesArgs URLS HEADERS)
	
	cmake_parse_arguments(download_distfile "${options}" "${oneValueArgs}" "${multipleValuesArgs}" ${ARGN})
	
	set(downloaded_file_path ${DOWNLOADS}/${download_distfile_FILENAME})
    set(download_file_path_part "${DOWNLOADS}/temp/${download_distfile_FILENAME}")
	file(MAKE_DIRECTORY "${DOWNLOADS}/temp")
	
	if(EXISTS "${downloaded_file_path}")
		message(STATUS "Using cached ${downloaded_file_path}")
	else()
		foreach(url IN LISTS download_distfile_URLS)
            message(STATUS "Downloading ${url}...")
            if(download_distfile_HEADERS)
                foreach(header ${vcpkg_download_distfile_HEADERS})
                    list(APPEND request_headers HTTPHEADER ${header})
                endforeach()
            endif()
            file(DOWNLOAD ${url} "${download_file_path_part}" STATUS download_status ${request_headers})
            list(GET download_status 0 status_code)
            if (NOT "${status_code}" STREQUAL "0")
                message(STATUS "Downloading ${url}... Failed. Status: ${download_status}")
                set(download_success 0)
            else()
                set(download_success 1)
                break()
            endif()
        endforeach(url)
		
		if (NOT download_success)
			MESSAGE(FATAL_ERROR
			"    \n"
            "    Failed to download file.\n")
		else()
			get_filename_component(downloaded_file_dir "${downloaded_file_path}" DIRECTORY)
			file(MAKE_DIRECTORY "${downloaded_file_dir}")
			file(RENAME ${download_file_path_part} ${downloaded_file_path})
		endif()
	endif()
	
	set(${VAR} ${downloaded_file_path} PARENT_SCOPE)
endfunction()