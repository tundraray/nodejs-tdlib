FROM node:18-slim as build

# Install git and bzip2
RUN apt-get -y update && apt-get -y upgrade && apt-get -qq -y install 
RUN apt-get install -y bzip2 git make zlib1g-dev libssl-dev gperf php-cli cmake clang libc++-dev libc++abi-dev
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /td-build

RUN git clone https://github.com/tdlib/td.git

RUN rm -rf td/build
WORKDIR /td-build/td
RUN mkdir build
WORKDIR /td-build/td/build
RUN CXXFLAGS="-stdlib=libc++" CC=/usr/bin/clang CXX=/usr/bin/clang++ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib .. && cmake --build . --target prepare_cross_compiling \
 && cd .. && php SplitSource.php && cd build && cmake --build . --target install && cd .. && php SplitSource.php --undo && cd ..
 
FROM node:18-slim
COPY --from=build /td-build/td/tdlib /usr/local
RUN apt-get install -y bzip2 zlib1g-dev libssl-dev libc++-dev libc++abi-dev
ENV PATH $HOME/.yarn/bin:$PATH
