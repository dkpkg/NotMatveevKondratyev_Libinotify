#!/bin/sh
set -eu

slot=$1
shift

mkdir -p "$slot/include/sys" "$slot/lib/pkgconfig" "$slot/lib" build
cp inotify.h "$slot/include/sys/inotify.h"
gcc "$@" -fPIC -O2 -c inotify-shim.c -o build/inotify-shim.o
gcc "$@" -shared -Wl,-soname,libinotify.so.0 -o "$slot/lib/libinotify.so.0.0.0" build/inotify-shim.o
ln -sf libinotify.so.0.0.0 "$slot/lib/libinotify.so.0"
ln -sf libinotify.so.0 "$slot/lib/libinotify.so"
ar rcs "$slot/lib/libinotify.a" build/inotify-shim.o
cat > "$slot/lib/libinotify.la" <<'EOF'
# libinotify.la - a libtool library file
dlname='libinotify.so.0'
library_names='libinotify.so.0.0.0 libinotify.so.0 libinotify.so'
old_library='libinotify.a'
inherited_linker_flags=''
dependency_libs=''
weak_library_names=''
current=0
age=0
revision=0
installed=yes
shouldnotlink=no
dlopen=''
dlpreopen=''
libdir='${prefix}/lib'
EOF
cp libinotify.pc "$slot/lib/pkgconfig/libinotify.pc"
