# build ninja
cd /project/linglong/sources/ninja.git
cmake -Bbuild
cmake --build build
ninja="$(pwd)/build/ninja"

# build libtorrent
cd /project/linglong/sources/libtorrent.git
cmake -Bbuild \
    -G Ninja \
    -DCMAKE_MAKE_PROGRAM=$ninja \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -Ddeprecated-functions=OFF \
    -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build build
cmake --install build

# build qBittorrent
cd /project/linglong/sources/qBittorrent.git
cmake -Bbuild \
    -G Ninja \
    -DCMAKE_MAKE_PROGRAM=$ninja \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build build
cmake --install build
