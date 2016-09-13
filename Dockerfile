FROM ubuntu:16.04
MAINTAINER Philip Branning <branning@gmail.com>

# just don't run sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# make login shell be a tty
RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

# do everything
ADD build_ubu1604.sh /root/build_ubu1604.sh
WORKDIR /root
RUN ./build_ubu1604.sh

