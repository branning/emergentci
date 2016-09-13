#!/bin/bash
#
# Build quarter and emergent from svn trunk on Ubuntu 16.04

set -o xtrace

quiet() 
{ 
  echo "Quietly running: $@"
  $@ >/dev/null 2>&1
}

detect_ncores()
{
  grep -c processor /proc/cpuinfo || echo 1
}

cores=`detect_ncores`

quiet apt-get update -y
quiet apt-get install -y \
                      csh \
                      cmake \
                      g++ \
                      clang \
                      python-pip \
                      mercurial \
                      subversion \
                      libsvn-dev \
                      devscripts \
                      pkg-config \
                      libreadline6-dev \
                      libncurses5-dev \
                      zlib1g-dev \
                      libcoin80-dev \
                      libsndfile1-dev \
                      libpng12-dev \
                      libjpeg-dev \
                      libode-dev \
                      libopenmpi-dev \
                      openmpi-bin \
                      libode-dev \
                      libgsl0-dev \
                      qt5-default \
                      qttools5-dev \
                      qtmultimedia5-dev \
                      qtlocation5-dev \
                      libqt5webkit5-dev \
                      libqt5designer5 \
                      libqt5svg5-dev \
;

# anonymous svn to checkout trunk of quarter and emergent
quiet svn checkout https://grey.colorado.edu/svn/emergent/emergent/trunk ~/emergent
quiet svn checkout https://grey.colorado.edu/svn/coin3d/quarter/trunk ~/quarter_trunk

# compile quarter
cd ~/quarter_trunk
./configure --build=x86_64-linux-gnu \
            --prefix=/usr \
            --includedir=${prefix}/include \
            --mandir=${prefix}/share/man \
            --infodir=${prefix}/share/info \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-silent-rules \
            --libexecdir=${prefix}/lib/libquarter0 \
            --disable-maintainer-mode \
            --disable-dependency-tracking \
            CPPFLAGS="-I/usr/include/x86_64-linux-gnu/qt5/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtCore/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtWidgets/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtOpenGL/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtGui/ -fPIC" \
            CONFIG_QTLIBS="-lQt5Core -lQt5OpenGL -lQt5Gui"
make -j ${cores}
make install

# compile emergent
cd ~/emergent
export CC=clang
export CXX=clang++
./configure --build=x86_64-linux-gnu \
            --prefix=/usr \
            --includedir=${prefix}/include \
            --mandir=${prefix}/share/man \
            --infodir=${prefix}/share/info \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --disable-silent-rules \
            --libexecdir=${prefix}/lib/libquarter0 \
            --disable-maintainer-mode \
            --disable-dependency-tracking \
            CPPFLAGS="-I/usr/include/x86_64-linux-gnu/qt5/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtCore/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtWidgets/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtOpenGL/ \
                      -I/usr/include/x86_64-linux-gnu/qt5/QtGui/ \
                      -fPIC" \
            CONFIG_QTLIBS="-lQt5Core -lQt5OpenGL -lQt5Gui" \
            --qt5
cd build
make -j ${cores}
