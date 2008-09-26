#~/bin/bash

# normal build


cd ../include/minizip
  gcc -c -I.. \
  -Dunix=1 \
  minizip.c miniunz.c zip.c unzip.c ioapi.c
cd ../qmus2mid
  g++ -c \
  qmus2mid.cpp
cd ../..

export includes="-I../include/pngpp -I../include -I.."
export mz_dir=../include/minizip
export qm_dir=../include/qmus2mid
export bs="g++ -Wall $includes unwad.cpp \
$qm_dir/qmus2mid.o \
$mz_dir/minizip.o $mz_dir/ioapi.o $mz_dir/zip.o $mz_dir/unzip.o"
export linked="-lmagic -lpng -lz"
export static="/usr/lib/libmagic.a /usr/lib/libpng.a /usr/lib/libz.a"

cd src
  echo building unwad
  $bs $linked -o unwad
  strip unwad
  if echo "$BUILD_STATIC" | grep -q "1"; then
      echo building unwad.static
      $bs $static -o unwad.static
      strip unwad.static
  fi
cd ..

rm include/minizip/*.o
rm include/qmus2mid/*.o
