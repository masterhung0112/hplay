cmake_minimum_required(VERSION 3.5)

project(mpegplay)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/")
include(common_functions)
set(DOWNLOADS ${CMAKE_CURRENT_LIST_DIR}/downloads)
file(MAKE_DIRECTORY ${DOWNLOADS})

set(BUILD_SCRIPT ${CMAKE_CURRENT_LIST_DIR}\\build.sh)
acquire_msys(MSYS_ROOT PACKAGES diffutils make)
set(BASH ${MSYS_ROOT}/usr/bin/bash.exe)

set(ROOT_DIR ${ROOT_DIR_CANDIDATE})
set(TARGET_TRIPLET x86-windows)
set(PORT ffmpeg_play)
set(CURRENT_INSTALLED_DIR ${ROOT_DIR}/installed/${TARGET_TRIPLET} CACHE PATH "Location to install final packages")
set(DOWNLOADS ${ROOT_DIR}/downloads CACHE PATH "Location to download sources and tools")
set(PACKAGES_DIR ${ROOT_DIR}/packages CACHE PATH "Location to store package images")
set(BUILDTREES_DIR ${ROOT_DIR}/buildtrees CACHE PATH "Location to perform actual extract+config+build")
set(CURRENT_BUILDTREES_DIR ${BUILDTREES_DIR}/${PORT})
set(CURRENT_PACKAGES_DIR ${PACKAGES_DIR}/${PORT}_${TARGET_TRIPLET})

#FILE(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}")
#FILE(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}")

download_distfile(ARCHIVE
    URLS "http://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2"
    FILENAME "ffmpeg-4.1.tar.bz2"
    SHA512 ccf6d07268dc47e08ca619eb182a003face2a8ee73ec1a28157330dd7de1df88939def1fc1c7e6b6ac7b59752cdad84657d589b2fafb73e14e5ef03fb6e33417
)

extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
#    PATCHES
#        create-lib-libraries.patch
#        detect-openssl.patch
#        configure_opencv.patch
#        fix_windowsinclude-in-ffmpegexe-1.patch
#        fix_windowsinclude-in-ffmpegexe-2.patch
#        fix_windowsinclude-in-ffmpegexe-3.patch
)


SET(ROOT_DIR_CANDIDATE ${CMAKE_CURRENT_LIST_DIR})
#while(IS_DIRECTORY ${ROOT_DIR_CANDIDATE} AND NOT EXISTS "${ROOT_DIR_CANDIDATE}/.vcpkg-root")
#    get_filename_component(ROOT_DIR_TEMP ${ROOT_DIR_CANDIDATE} DIRECTORY)
#    if (ROOT_DIR_TEMP STREQUAL ROOT_DIR_CANDIDATE) # If unchanged, we have reached the root of the drive
#        message(FATAL_ERROR "Could not find .vcpkg-root")
#    else()
#        SET(ROOT_DIR_CANDIDATE ${ROOT_DIR_TEMP})
#    endif()
#endwhile()

find_acquire_program(YASM)
get_filename_component(YASM_EXE_PATH ${YASM} DIRECTORY)

set(ENV{INCLUDE} "${CURRENT_INSTALLED_DIR}/include;$ENV{INCLUDE}")
set(ENV{LIB} "${CURRENT_INSTALLED_DIR}/lib;$ENV{LIB}")

set(_csc_PROJECT_PATH ffmpeg)

file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)

set(OPTIONS "--enable-asm --enable-yasm --disable-doc --enable-debug")
set(OPTIONS "${OPTIONS} --enable-runtime-cpudetect")
set(OPTIONS_RELEASE "")

message(STATUS "Building ${_csc_PROJECT_PATH} for Release")
file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
execute_required_process(
    COMMAND ${BASH} --noprofile --norc "${BUILD_SCRIPT}"
        "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel" # BUILD DIR
        "${SOURCE_PATH}" # SOURCE DIR
        "${CURRENT_PACKAGES_DIR}" # PACKAGE DIR
        "${OPTIONS} ${OPTIONS_RELEASE}"
    WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
    LOGNAME build-${TARGET_TRIPLET}-rel
)