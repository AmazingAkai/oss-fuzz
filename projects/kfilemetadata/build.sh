#!/bin/bash -eu
# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

# Build zlib
cd $SRC/zlib
./configure --static
make install -j$(nproc)

# Build qtbase
cd $SRC/qtbase
./configure \
  -no-glib \
  -qt-libpng \
  -qt-pcre \
  -opensource \
  -confirm-license \
  -static \
  -no-opengl \
  -no-icu \
  -platform linux-clang-libc++ \
  -debug \
  -prefix /usr \
  -no-feature-sql \
  -no-feature-dbus \
  -no-feature-printsupport
cmake --build . --parallel $(nproc)
cmake --install .

# Build qttools
cd $SRC/qttools
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build . --parallel $(nproc)
cmake --install .

# Build extra-cmake-modules
cd $SRC/extra-cmake-modules
cmake . -G Ninja
cmake --build . --parallel $(nproc)
cmake --install .

cd $SRC/karchive
rm -rf poqm
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF \
  -DWITH_BZIP2=OFF \
  -DWITH_LIBLZMA=OFF \
  -DWITH_OPENSSL=OFF \
  -DWITH_LIBZSTD=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build qtdeclarative
cd $SRC/qtdeclarative
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build . --parallel $(nproc)
cmake --install .

# Build kcoreaddons
cd $SRC/kcoreaddons
rm -rf poqm
cmake . \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF \
  -DBUILD_PYTHON_BINDINGS=OFF \
  -DUSE_DBUS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build kcodecs
cd $SRC/kcodecs
rm -rf poqm
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build kconfig
cd $SRC/kconfig
rm -rf poqm
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF \
  -DKCONFIG_USE_GUI=OFF \
  -DKCONFIG_USE_QML=OFF \
  -DUSE_DBUS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build ki18n
cd $SRC/ki18n
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build poppler
cd $SRC/poppler
# TODO
# cmake -B build \
#   -DENABLE_UNSTABLE_API_ABI_HEADERS=OFF \
#   -DBUILD_GTK_TESTS=OFF \
#   -DBUILD_QT5_TESTS=OFF \
#   -DBUILD_QT6_TESTS=OFF \
#   -DBUILD_CPP_TESTS=OFF \
#   -DBUILD_MANUAL_TESTS=OFF \
#   -DENABLE_BOOST=OFF \
#   -DENABLE_UTILS=OFF \
#   -DENABLE_CPP=OFF \
#   -DENABLE_GLIB=OFF \
#   -DENABLE_GOBJECT_INTROSPECTION=OFF \
#   -DENABLE_GTK_DOC=OFF \
#   -DENABLE_QT5=OFF \
#   -DENABLE_QT6=ON \
#   -DENABLE_LCMS=OFF \
#   -DENABLE_LIBCURL=OFF \
#   -DENABLE_LIBTIFF=OFF \
#   -DENABLE_NSS3=OFF \
#   -DENABLE_GPGME=OFF \
#   -DENABLE_PGP_SIGNATURES=OFF \
#   -DENABLE_ZLIB_UNCOMPRESS=OFF \
#   -DBUILD_SHARED_LIBS=OFF \
#   -DRUN_GPERF_IF_PRESENT=OFF \
#   -DINSTALL_GLIB_DEMO=OFF \
#   -DENABLE_RELOCATABLE=OFF

# Install utf8cpp
cd $SRC
tar -xzf utfcpp-*.tar.gz && rm -f utfcpp-*.tar.gz
cp -r utfcpp-*/source/* /usr/include/

# Build taglib
cd $SRC/taglib
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build brotli
cd $SRC/brotli
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build expat
cd $SRC/libexpat/expat
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DEXPAT_BUILD_TESTS=OFF \
  -DEXPAT_BUILD_EXAMPLES=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build fmt
cd $SRC/fmt
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DFMT_DOC=OFF \
  -DFMT_TEST=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build exiv2
cd $SRC/exiv2
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DEXIV2_ENABLE_INIH=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build ffmpeg (avcodec, avformat, avutil)
cd $SRC/ffmpeg
if [ "$SANITIZER" = "memory" ]; then
  disable_asm=--disable-x86asm
else
  disable_asm=
fi
./configure \
  --cc="$CC" \
  --cxx="$CXX" \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CXXFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --pkg-config-flags="--static" \
  --prefix=/usr \
  --enable-static \
  --disable-shared \
  $disable_asm \
  --disable-doc \
  --disable-everything \
  --disable-programs \
  --disable-avdevice \
  --disable-avfilter \
  --disable-swresample \
  --disable-swscale \
  --enable-avcodec \
  --enable-avformat \
  --enable-avutil
make install -j$(nproc)

# Build libzip
cd $SRC/libzip
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build libxml2
cd $SRC/libxml2
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build epub
cd $SRC
tar -xzf ebook-tools-*.tar.gz && rm -f ebook-tools-*.tar.gz
cd ebook-tools-*
# disable the cli tools
sed -i '/add_subdirectory (tools)/d' src/CMakeLists.txt
# allow static build
sed -i 's/add_library (epub SHARED/add_library (epub/' src/libepub/CMakeLists.txt
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build catdoc
cd $SRC/catdoc
# TODO: Runtime dependency (executable), verify if this works
./configure --prefix=$OUT/catdoc-install
make install -j$(nproc)

# Build attr
cd $SRC
tar -xzf attr-*.tar.gz && rm -f attr-*.tar.gz
cd attr-*
./configure --enable-static --disable-shared
make install -j$(nproc)

# Build qt5compat
cd $SRC/qt5compat
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_INSTALL_PREFIX=/usr
cmake --build . --parallel $(nproc)
cmake --install .

# Build kdegraphics-mobipocket
cd $SRC/kdegraphics-mobipocket
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF
cmake --build . --parallel $(nproc)
cmake --install .

# Build libappimage
cd $SRC/libappimage
# -- TODO: optional --

# Build kfilemetadata
cd $SRC/kfilemetadata
rm -rf po
cmake . -G Ninja \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_TESTING=OFF
cmake --build . --parallel $(nproc)
cmake --install .
