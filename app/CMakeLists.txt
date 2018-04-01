# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)

#set(OPENCV_SDK_DIR "C:/01-libs/OpenCV-android-sdk")

# Creates and names a library, sets ilt as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds them for you.
# Gradle automatically packages shared libraries with your APK.

add_library( # Sets the name of the library.
             detection_based_tracker

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             src/main/cpp/DetectionBasedTracker_jni.cpp
             #src/main/cpp/DetectionBasedTracker_jni.h
             )

# Searches for a specified prebuilt library and stores the path as a
# variable. Because CMake includes system libraries in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

# Path for OpenCV atm src/main/jniLibs/x86_64
# Need different paths for ARM and ARMv7

include_directories("${OPENCV_SDK_DIR}/sdk/native/jni/include")
set(OPENCV_CPP_LIB_PATH "${OPENCV_SDK_DIR}/sdk/native/staticlibs/${ANDROID_ABI}")
set(OPENCV_CPP_DEP_LIB_PATH "${OPENCV_SDK_DIR}/sdk/native/3rdparty/libs/${ANDROID_ABI}/")

message(AUTHOR_WARNING ${CMAKE_CURRENT_SOURCE_DIR})

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/x86_64/libopencv_java3.so")
    message(AUTHOR_WARNING "OpenCV lib exits")
else()
    message("NO OpenCV lib")
endif()

message("ABI = ${ANDROID_ABI}")

#find_library ( OPENCV_LIB
#        NAMES libopencv_java3.so libopencv_java3 opencv_java3
#        HINTS "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/x86_64/"
#        )

if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java3.so)
    message(FATAL "OpenCV Java lib doesn't exist for ARCH=${ANDROID_ABI}")
endif()

# Java Lib needed by the Java code
add_library( OPENCV_JAVA_LIB
             SHARED
             IMPORTED )
set_target_properties( # Specifies the target library.
                       OPENCV_JAVA_LIB

                       # Specifies the parameter you want to define.
                       PROPERTIES IMPORTED_LOCATION

                       # Provides the path to the library you want to import.
                       ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java3.so )

# Checking that the native libs exists
# Better would be to create the list of libs for every architecture (they are different)
# then iterate over that list and check that they exist
if (NOT EXISTS ${OPENCV_CPP_LIB_PATH}/libopencv_core.a)
    message(FATAL "libopencv_core.a not found")
endif()
if (NOT EXISTS ${OPENCV_CPP_LIB_PATH}/libopencv_objdetect.a)
    message(FATAL "libopencv_objdetect.a not found")
endif()

# TODO add checking for OpenCV library and include

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

set (  OPENCV_LIBS
       ${OPENCV_CPP_LIB_PATH}/libopencv_imgcodecs.a
       ${OPENCV_CPP_LIB_PATH}/libopencv_objdetect.a
       ${OPENCV_CPP_LIB_PATH}/libopencv_highgui.a
       ${OPENCV_CPP_LIB_PATH}/libopencv_imgproc.a
       ${OPENCV_CPP_LIB_PATH}/libopencv_video.a
       # Core needs to be last of the OpenCV libs to include otherwise we get undefined symbols
       ${OPENCV_CPP_LIB_PATH}/libopencv_core.a
       ${OPENCV_CPP_DEP_LIB_PATH}/libtbb.a
       )
if( ${ANDROID_ABI} MATCHES "x86_64" OR ${ANDROID_ABI} MATCHES "x86")
    list ( APPEND OPENCV_LIBS
           ${OPENCV_CPP_DEP_LIB_PATH}/libippiw.a
           ${OPENCV_CPP_DEP_LIB_PATH}/libippicv.a
           ${OPENCV_CPP_DEP_LIB_PATH}/libittnotify.a
           )
else()
    list ( APPEND OPENCV_LIBS
           ${OPENCV_CPP_DEP_LIB_PATH}/libtegra_hal.a
           ${OPENCV_CPP_DEP_LIB_PATH}/libcpufeatures.a
           )
endif()

target_link_libraries( # Specifies the target library.
                       detection_based_tracker

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib}
                       ${OPENCV_JAVA_LIB}
                       ${OPENCV_LIBS}


#                      ${OPENCV_CPP_LIB_PATH}/libopencv_features2d.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_dnn.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_calib3d.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_flann.a


#                       ${OPENCV_CPP_LIB_PATH}/libopencv_ml.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_photo.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_shape.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_stitching.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_superres.a

#                       ${OPENCV_CPP_LIB_PATH}/libopencv_videoio.a
#                       ${OPENCV_CPP_LIB_PATH}/libopencv_videostab.a

#                       ${OPENCV_CPP_DEP_LIB_PATH}/libIlmImf.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/libcpufeatures.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibjasper.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibjpeg.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibpng.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibtiff.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibprotobuf.a
#                       ${OPENCV_CPP_DEP_LIB_PATH}/liblibwebp.a
                       z
                       m
                       dl
                       )