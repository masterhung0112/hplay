cmake_minimum_required(VERSION 3.5)

project(mpegplay)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/")
include(common_functions)
set(DOWNLOADS ${CMAKE_CURRENT_LIST_DIR}/downloads)
file(MAKE_DIRECTORY ${DOWNLOADS})

acquire_msys(MSYS_ROOT PACKAGES perl gcc diffutils make)

download_distfile(ARCHIVE
    URLS "http://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2"
    FILENAME "ffmpeg-4.1.tar.bz2"
    SHA512 ccf6d07268dc47e08ca619eb182a003face2a8ee73ec1a28157330dd7de1df88939def1fc1c7e6b6ac7b59752cdad84657d589b2fafb73e14e5ef03fb6e33417
)