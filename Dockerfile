# Используйте Ubuntu 20.04 как базовый образ
FROM ubuntu:20.04

# Установите необходимые зависимости
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    git \
    libatlas-base-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libopencv-dev \
    python3-dev \
    python3-pip \
    libboost-all-dev \
    libspdlog-dev \
    libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

# Установите Python зависимости
RUN pip3 install numpy rospkg catkin_pkg

# Клонируйте и соберите DBoW2 (пример для зависимости, повторите для других)
RUN git clone https://github.com/shinsumicco/DBoW2.git && \
    cd DBoW2 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# Клонируйте и соберите g2o (еще одна зависимость)
RUN git clone https://github.com/RainerKuemmerle/g2o.git && \
    cd g2o && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# Клонируйте и соберите OpenVSLAM
RUN git clone --depth 1 https://github.com/xdspacelab/openvslam.git
RUN cd openvslam && \
    mkdir build && \
    cd build && \
    cmake \
    -DBUILD_WITH_MARCH_NATIVE=OFF \
    -DUSE_PANGOLIN_VIEWER=OFF \
    -DUSE_SOCKET_PUBLISHER=OFF \
    -DUSE_STACK_TRACE_LOGGER=OFF \
    -DBOW_FRAMEWORK=DBoW2 \
    .. && \
    make -j$(nproc) && \
    make install

# Добавьте ваш код или данные
COPY . /app

# Укажите рабочую директорию
WORKDIR /app

# Укажите команду для запуска (пример)
CMD ["bash"]