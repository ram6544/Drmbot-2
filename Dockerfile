FROM python:3.9-slim-bullseye

WORKDIR /app
COPY . .

# System dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    cmake \
    aria2 \
    wget \
    pv \
    jq \
    python3-dev \
    ffmpeg \
    mediainfo \
    && rm -rf /var/lib/apt/lists/*

# Bento4 build
RUN git clone https://github.com/axiomatic-systems/Bento4.git && \
    cd Bento4 && \
    mkdir cmakebuild && \
    cd cmakebuild && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j$(nproc) && \
    make install

# Python deps
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "main.py"]
