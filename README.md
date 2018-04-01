# OpenCV face detection sample

Made with Android Studio
Source code copied from OpenCV Android package (version 3.41)
Sample provides face tracking using both Java and Native implementations

## Compile Instructions
- Install Android Studio
- Get OpenCV Android Pack
https://opencv.org/releases.html
- pull the project
- Open the project with Android Studio
- Add OpenCV library to the project
    - File -> New -> Import Module (pick the OpenCV Pack directory)
- copy the jni libs (these will give you java interface for OpenCV)
libopencv_java3.so :
    from OpenCV-android-sdk\sdk\native\libs\x86_64 (and armeabi)
    to   app\src\main\jniLibs\x86_64 (and armeabi)
- Change the Hard-coded path in build.gradle (Module: app)
    OPENCV_SDK_DIR to the directory you extracted the Android Pack
- Compile
- Upload to Phone
If using an emulator, be aware that webcamera seems to have some problems.

