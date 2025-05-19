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

FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get update && \
    apt-get install -y make autoconf automake libtool ninja-build \
    gettext pkgconf nasm desktop-file-utils libglib2.0-dev libcairo2-dev \
    librsvg2-dev po4a autopoint

RUN git clone --depth 1 https://github.com/madler/zlib.git
RUN git clone --depth 1 -b dev git://code.qt.io/qt/qtbase.git
RUN git clone --depth 1 -b dev git://code.qt.io/qt/qttools.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/extra-cmake-modules.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/karchive.git
RUN git clone --depth 1 -b dev git://code.qt.io/qt/qtdeclarative.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/kcoreaddons.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/kcodecs.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/kconfig.git
RUN git clone --depth 1 -b master https://invent.kde.org/frameworks/ki18n.git
RUN git clone --depth 1 https://gitlab.freedesktop.org/poppler/poppler.git
RUN wget https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.0.6.tar.gz -O utfcpp-4.0.6.tar.gz
RUN git clone --depth 1 https://github.com/taglib/taglib.git
RUN git clone --depth 1 https://github.com/google/brotli.git
RUN git clone --depth 1 https://github.com/libexpat/libexpat.git
RUN git clone --depth 1 https://github.com/fmtlib/fmt.git
RUN git clone --depth 1 https://github.com/exiv2/exiv2.git
RUN git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git
RUN git clone --depth 1 https://github.com/nih-at/libzip.git
RUN git clone --depth 1 https://gitlab.gnome.org/GNOME/libxml2.git
RUN wget https://sourceforge.net/projects/ebook-tools/files/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz
RUN git clone http://www.wagner.pp.ru/git/oss/catdoc.git
# Mostly fails with a 502 :/
# RUN git clone --depth 1 https://git.savannah.nongnu.org/git/attr.git
RUN wget https://download-mirror.savannah.gnu.org/releases/attr/attr-2.5.2.tar.gz
RUN git clone --depth 1 -b dev git://code.qt.io/qt/qt5compat.git
RUN git clone --depth 1 -b master https://invent.kde.org/graphics/kdegraphics-mobipocket.git
RUN git clone --depth 1 https://github.com/AppImageCommunity/libappimage.git
RUN git clone --depth 1 https://invent.kde.org/frameworks/kfilemetadata.git

COPY build.sh $SRC/
WORKDIR $SRC/kfilemetadata
