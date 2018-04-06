# For more information about using CMake with Android Studio, read the
# documentation: https://d.android.com/studio/projects/add-native-code.html

# Sets the minimum version of CMake required to build the native library.

cmake_minimum_required(VERSION 3.4.1)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

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

# Check that the OpenCV Java library exists
if(NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java3.so)
    message(FATAL "OpenCV Java lib doesn't exist for ARCH=${ANDROID_ABI}")
endif()

# Java Lib needed by the Java code
add_library( OPENCV_JAVA_LIB
             SHARED
             IMPORTED )
set_target_properties(
       OPENCV_JAVA_LIB

       # Specifies the parameter you want to define.
       PROPERTIES IMPORTED_LOCATION

       # Provides the path to the library you want to import.
       ${CMAKE_CURRENT_SOURCE_DIR}/src/main/jniLibs/${ANDROID_ABI}/libopencv_java3.so
       )

find_package(OpenCV REQUIRED)

# Compile the CPP module using OpenCV
include_directories(${OPENCV_INCLUDE_DIR})

target_link_libraries( # Specifies the target library.
                       detection_based_tracker

                       # Link to Native libs
                       ${log-lib}
                       ${OPENCV_JAVA_LIB}
                       ${OPENCV_LIBS}
                       )