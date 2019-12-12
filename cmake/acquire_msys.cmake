function(acquire_msys PATH_TO_ROOT_OUT)
	cmake_parse_arguments(_am "" "" "PACKAGES" ${ARGN})

	set(TOOLPATH ${DOWNLOADS}/tools/msys2)
	
	set(TOOLSUBPATH msys32)
    set(URLS
      "http://repo.msys2.org/distrib/i686/msys2-base-i686-20181211.tar.xz"
    )
    set(ARCHIVE "msys2-base-i686-20181211.tar.xz")
    set(HASH a9b9680a511bb205b87811b303eb29d62e2fd851000304f8b087c5893a3891c2aa2d46217ae989e31b5d52a6ba34ac5e6a5e624d9c917df00a752ade4debc20f)
    set(STAMP "initialized-msys2_32.stamp")
	
	set(PATH_TO_ROOT ${TOOLPATH}/${TOOLSUBPATH})
	
	if(NOT EXISTS "${TOOLPATH}/${STAMP}")
		message(STATUS "Acquiring MSYS2...")
		download_distfile(ARCHIVE_PATH
			URLS ${URLS}
			FILENAME ${ARCHIVE}
			SHA512 ${HASH}
		)
		
		file(REMOVE_RECURSE ${TOOLPATH}/${TOOLSUBPATH})
		file(MAKE_DIRECTORY ${TOOLPATH})
		execute_process(
			COMMAND ${CMAKE_COMMAND} -E tar xzf ${ARCHIVE_PATH}
			WORKING_DIRECTORY ${TOOLPATH}
		)
		execute_process(
			COMMAND ${PATH_TO_ROOT}/usr/bin/bash.exe --noprofile --norc -c "PATH=/usr/bin;pacman-key --init;pacman-key --populate"
			WORKING_DIRECTORY ${TOOLPATH}
		)
		
		execute_process(
			COMMAND ${PATH_TO_ROOT}/usr/bin/bash.exe --noprofile --norc -c "PATH=/usr/bin;pacman -Syu --noconfirm"
			WORKING_DIRECTORY ${TOOLPATH}
		)
		file(WRITE "${TOOLPATH}/${STAMP}" "0")
		message(STATUS "Acquiring MSYS2... OK")
	endif()
	
	if(_am_PACKAGES)
		message(STATUS "Acquiring MSYS Packages...")
		string(REPLACE ";" " " _am_PACKAGES "${_am_PACKAGES}")
		
		set(_ENV_ORIGINAL $ENV{PATH})
		set(ENV{PATH} ${PATH_TO_ROOT}/usr/bin)
		execute_process(
			COMMAND ${PATH_TO_ROOT}/usr/bin/bash.exe --noprofile --norc -c "pacman -Sy --noconfirm --needed ${_am_PACKAGES}"
			WORKING_DIRECTORY ${TOOLPATH}
		)
		set(ENV{PATH} "${_ENV_ORIGINAL}")
		
		message(STATUS "Acquiring MSYS Packages... OK")
	endif()
	
	set(${PATH_TO_ROOT_OUT} ${PATH_TO_ROOT} PARENT_SCOPE)
endfunction()