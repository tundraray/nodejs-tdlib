FROM node:18-slim

# Install git and bzip2
RUN apt-get -y update && apt-get -y upgrade && apt-get -qq -y install 
RUN apt-get install -y bzip2 git make zlib1g-dev libssl-dev gperf php-cli cmake clang libc++-dev libc++abi-dev
RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/tdlib/td.git
RUN rm -rf td/build
RUN cd td && mkdir build
RUN cd td/build && CXXFLAGS="-stdlib=libc++" CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. && cmake --build . --target install

RUN rm -rf td


ENV PATH $HOME/.yarn/bin:$PATH