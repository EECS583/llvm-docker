FROM debian:12.5 AS build
RUN apt update
RUN apt install -y git cmake make gcc 
RUN git clone https://github.com/llvm/llvm-project.git && mkdir llvm-project/build
# COPY ./llvm-project /llvm-project
WORKDIR llvm-project/build
RUN apt install -y g++ python3
RUN cmake -DLLVM_ENABLE_PROJECTS="clang;compiler-rt" -DCMAKE_BUILD_TYPE=Release -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/llvm-install ../llvm && make install -j4

FROM debian:12.5
WORKDIR /
COPY --from=build /llvm-install/ /usr/local/
RUN apt update && apt install -y git cmake make gcc g++ python3
