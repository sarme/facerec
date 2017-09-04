FROM ubuntu:16.04
MAINTAINER Sean Arme

# setup environment
RUN apt-get update && \
  apt-get install -y build-essential apt-utils \
  cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
  python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libjasper-dev libdc1394-22-dev \
  python-pip python-opencv libopencv-dev libav-tools python-pycurl \
  libatlas-base-dev gfortran webp qt5-default libvtk6-dev zlib1g-dev && \
  pip install --upgrade pip && \
  pip install numpy && pip install pillow && pip install argparse && \
  ln /dev/null /dev/raw1394

# get, compile, and install OpenCV
RUN cd ~/ &&\
  export NUMCPUS=`grep -c '^processor' /proc/cpuinfo` && \
  git clone https://github.com/opencv/opencv.git && \
  git clone https://github.com/opencv/opencv_contrib.git && \
  cd opencv && mkdir build && cd build && cmake  -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules .. && \
  make -j$NUMCPUS --load-average=$NUMCPUS && make install && ldconfig && rm -rf ~/opencv* && apt-get autoclean && apt-get clean

# get facerec
RUN curl https://raw.githubusercontent.com/sarme/facerec/master/facerec>/usr/local/bin/facerec;chmod +x /usr/local/bin/facerec


