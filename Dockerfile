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

# Create config at build time
RUN mkdir -p /root/.config/openclaw && \
    printf '<?xml version="1.0" encoding="utf-8"?>\n\
<Config>\n\
    <Display>\n\
        <Screen width="1024" height="768" scale="1"/>\n\
        <Fullscreen>0</Fullscreen>\n\
    </Display>\n\
    <Audio>\n\
        <Frequency>22050</Frequency>\n\
        <SoundChannels>16</SoundChannels>\n\
        <MixingChannels>16</MixingChannels>\n\
        <SoundVolume>50</SoundVolume>\n\
        <MusicVolume>50</MusicVolume>\n\
    </Audio>\n\
    <Assets>\n\
        <CustomArchive>ASSETS_PATH</CustomArchive>\n\
    </Assets>\n\
</Config>\n' > /root/.config/openclaw/config.xml && \
    cat /root/.config/openclaw/config.xml

EXPOSE 8080

CMD Xvfb :99 -screen 0 1024x768x16 & export DISPLAY=:99 && ./Build_Release/openclaw