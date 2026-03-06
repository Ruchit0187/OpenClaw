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
    xvfb \
    git

WORKDIR /app
COPY . .

RUN mkdir build && cd build && cmake .. && make -j$(nproc)

# Create config directory and copy default config
RUN mkdir -p /root/.config/openclaw
COPY config.xml /root/.config/openclaw/config.xml

EXPOSE 8080

CMD Xvfb :99 -screen 0 1024x768x16 & export DISPLAY=:99 && ./Build_Release/openclaw