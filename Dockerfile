FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libsdl2-dev \
    libsdl2-mixer-dev \
    libsdl2-image-dev \
    libsdl2-ttf-dev \
    libsdl2-net-dev \
    libsdl2-gfx-dev \
    libpng-dev \
    zlib1g-dev \
    git

WORKDIR /app
COPY . .

RUN mkdir build && cd build && cmake .. && make -j$(nproc)

EXPOSE 8080
CMD ["./Build_Release/openclaw"]