# max build time 2h
sleep 7200 && kill -SIGKILL $$ &
# install packages
install_pkg=$(realpath "./install_pkg.sh")
include_pkg=''
exclude_pkg=''
bash $install_pkg -i -d $(realpath 'linglong/sources') -p $PREFIX -I \"$include_pkg\" -E \"$exclude_pkg\"
export LD_LIBRARY_PATH=$PREFIX/lib/$TRIPLET:$LD_LIBRARY_PATH

# build ninja
cd /project/linglong/sources/ninja.git
cmake -Bbuild
cmake --build build -j$(nproc)
ninja="$(pwd)/build/ninja"

# build libtorrent
cd /project/linglong/sources/libtorrent.git
cmake -Bbuild \
    -G Ninja \
    -DCMAKE_MAKE_PROGRAM=$ninja \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -Ddeprecated-functions=OFF \
    -DCMAKE_INSTALL_PREFIX=build/install \
    -DCMAKE_INSTALL_LIBDIR=$PREFIX/lib/$TRIPLET \
    -DCMAKE_INSTALL_INCLUDEDIR=$PREFIX/include
cmake --build build -j1
cmake --install build

# build qBittorrent
cd /project/linglong/sources/qBittorrent.git
cmake -Bbuild \
    -G Ninja \
    -DCMAKE_MAKE_PROGRAM=$ninja \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX
cmake --build build -j1
cmake --install build

# fix QT_PLUGIN_PATH
{
  echo "[Paths]"
  echo "Prefix=$PREFIX"
  echo "Plugins=lib/${TRIPLET}/qt6/plugins"
} > ${PREFIX}/bin/qt.conf

rm -r $PREFIX/include
# uninstall dev packages
bash $install_pkg -u -r '\-dev|tools|qmake6'
