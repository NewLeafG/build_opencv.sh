#!/usr/bin/env bash

OPENCV_DIR=../../src
INSTALL_DIR=$HOME/adas/3rdparty

TEST_OPTS="-DBUILD_TESTS=OFF \
           -DBUILD_PERF_TESTS=OFF \
           -DBUILD_EXAMPLES=OFF"

PKG_OPTS="-DWITH_OPENEXR=OFF \
          -DWITH_JPEG=OFF \
          -DWITH_WEBP=OFF \
          -DWITH_JASPER=OFF \
          -DWITH_TIFF=OFF \
          -DWITH_PNG=OFF"

MODULE_OPTS="-DBUILD_opencv_reg=OFF \
             -DBUILD_opencv_surface_matching=OFF \
             -DBUILD_opencv_dnn=OFF \
             -DBUILD_opencv_fuzzy=OFF \
             -DBUILD_opencv_plot=OFF \
             -DBUILD_opencv_superres=OFF \
             -DBUILD_opencv_xobjdetect=OFF \
             -DBUILD_opencv_xphoto=OFF \
             -DBUILD_opencv_bgsegm=OFF \
             -DBUILD_opencv_bioinspired=OFF \
             -DBUILD_opencv_dpm=OFF \
             -DBUILD_opencv_face=OFF \
             -DBUILD_opencv_line_descriptor=OFF \
             -DBUILD_opencv_saliency=OFF \
             -DBUILD_opencv_text=OFF \
             -DBUILD_opencv_ccalib=OFF \
             -DBUILD_opencv_datasets=OFF \
             -DBUILD_opencv_java=OFF \
             -DBUILD_opencv_rgbd=OFF \
             -DBUILD_opencv_stereo=OFF \
             -DBUILD_opencv_structured_light=OFF \
             -DBUILD_opencv_tracking=OFF \
             -DBUILD_opencv_videostab=OFF \
             -DBUILD_opencv_ximgproc=OFF \
             -DBUILD_opencv_aruco=OFF \
             -DBUILD_opencv_optflow=OFF \
             -DBUILD_opencv_stitching=OFF"

PERF_OPTS="-DWITH_TBB=ON -DBUILD_WITH_DEBUG_INFO=OFF -DWITH_OPENCL=ON"

ANDROID_OPTS="-DBUILD_ANDROID_EXAMPLES=OFF \
              -DCMAKE_BUILD_WITH_INSTALL_RPATH=on \
              -DCMAKE_TOOLCHAIN_FILE=$OPENCV_DIR/opencv/platforms/android/android.toolchain.cmake \
              ANDROID_NATIVE_API_LEVEL=android-21"

function build_opencv {
    PLATFORM=$1

    if [ "$PLATFORM" == "android" ]; then
        ABI=$2
        BUILD_DIR=$ABI
        OPTIONS="-DANDROID_ABI=$ABI $ANDROID_OPTS"

        # Setup OpenCL for Mali
        export OPENCV_OPENCL_RUNTIME=libGLES_mali.so
    else
        BUILD_DIR=$PLATFORM
        OPTIONS="-DWITH_1394=OFF"
    fi

    echo "Building Opencv for $*"
    mkdir -p $BUILD_DIR
    pushd $BUILD_DIR

    cmake \
    $OPTIONS \
    $TEST_OPTS \
    $PKG_OPTS \
    $PERF_OPTS \
    $MODULE_OPTS \
    -GNinja \
    -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_DIR/opencv_contrib/modules \
    -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
    $OPENCV_DIR/opencv

    ninja
    ninja install

    popd
}

build_opencv pc
build_opencv android armeabi-v7a
build_opencv android arm64-v8a