# Find OpenCV C++ library
#
# OpenCV cmake finder for Android
#
# Requires
# OPENCV_SDK_DIR to be defined and pointing to Android distribution of OpenCV
#
# Defines
# OPENCV_INCLUDE_DIR    - All headers
# OPENCV_LIBS           - Required libs (only some are included)
# OPENCV_FOUND          - True if found, false otherwise
#
# TODO
# Very incomplete since we can't configure which opencv libs we are using
# Doesn't comply with the best practices of Find scripts
# Doesn't respect FIND_QUIETLY or REQUIRED

# For CPP, moving these to Find script
set(OPENCV_INCLUDE_DIR "${OPENCV_SDK_DIR}/sdk/native/jni/include")
set(OPENCV_CPP_LIB_PATH "${OPENCV_SDK_DIR}/sdk/native/staticlibs/${ANDROID_ABI}")
set(OPENCV_CPP_DEP_LIB_PATH "${OPENCV_SDK_DIR}/sdk/native/3rdparty/libs/${ANDROID_ABI}/")

# Checking that the native libs exists
# Better would be to create the list of libs for every architecture (they are different)
# then iterate over that list and check that they exist
if (NOT EXISTS ${OPENCV_CPP_LIB_PATH}/libopencv_core.a)
    set(OPENCV_FOUND FALSE CACHE BOOL "" FORCE)
    message(FATAL "libopencv_core.a not found")
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
       # Dependencies needed
       z
       m
       dl
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
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_features2d.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_dnn.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_calib3d.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_flann.a


#                      ${OPENCV_CPP_LIB_PATH}/libopencv_ml.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_photo.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_shape.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_stitching.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_superres.a

#                      ${OPENCV_CPP_LIB_PATH}/libopencv_videoio.a
#                      ${OPENCV_CPP_LIB_PATH}/libopencv_videostab.a

#                      ${OPENCV_CPP_DEP_LIB_PATH}/libIlmImf.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/libcpufeatures.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibjasper.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibjpeg.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibpng.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibtiff.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibprotobuf.a
#                      ${OPENCV_CPP_DEP_LIB_PATH}/liblibwebp.a

set(OPENCV_FOUND TRUE CACHE BOOL "" FORCE)
